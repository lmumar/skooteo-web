# frozen_string_literal: true

class Spot::Booking
  extend ActiveModel::Naming

  InvalidBooking = Class.new(ActiveRecord::Rollback)
  InsufficentCredits = Class.new(ActiveRecord::Rollback)
  SpotUnavailable = Class.new(ActiveRecord::Rollback)

  include ActiveModel::Validations
  include AASM

  attr_accessor :campaign_name
  attr_accessor :items

  validates_presence_of :campaign_name

  aasm column: 'state' do
    state :initialised, initial: true
    state :calculated
    state :confirmed, before_enter: :save

    event :calculate do
      transitions from: :initialised, to: :calculated
    end

    event :book do
      transitions from: :calculated, to: :confirmed
    end
  end

  class << self
    def reset(campaign, items, repeat: nil, day_intervals: 1)
      booking_items = items.inject([]) { |list, item|
        list << Spot::BookingItem.new(item[:item])
      }

      if repeat
        clones = Spot::BookingItem.bulk_clone(booking_items, repeat, day_intervals)
        booking_items.concat(clones.sort_by(&:etd))
      end

      booking = new(
        campaign_name: campaign,
        items: booking_items
      )
      booking.calculate
      booking
    end
  end

  def initialize(campaign_name: '', items: [])
    @campaign_name = campaign_name
    @items = items
    @read_only = false
  end

  def <<(booking_item)
    raise(ArgumentError) unless booking_item.present? && booking_item.is_a?(Spot::BookingItem)
    @items << booking_item
  end

  def items_with_bookings
    @rows_with_bookings ||= self.items.select(&:has_bookings?)
  end

  def total_regular_booking_count
    self.items_with_bookings
      .select(&:has_regular_bookings?)
      .sum { |row| row.booked_regular_spots.to_i }
  end

  def total_regular_booking_cost
    self.items_with_bookings.sum(&:regular_booking_cost)
  end

  def total_premium_booking_count
    self.items_with_bookings
      .select(&:has_premium_bookings?)
      .sum { |row| row.booked_premium_spots.to_i }
  end

  def total_premium_booking_cost
    self.items_with_bookings.sum(&:premium_booking_cost)
  end

  def total_booking_cost
    self.total_premium_booking_cost + self.total_regular_booking_cost
  end

  private
    def save
      remaining_credits = Current.company.credits.sum(:amount)
      if remaining_credits < total_booking_cost
        raise InsufficentCredits, "Not enough credits"
      end

      if items_with_bookings.size.zero?
        raise InvalidBooking, "Empty booking"
      end

      vehicle_schedule_index = VehicleRouteSchedule
        .includes(:vehicle_route, :route, :company)
        .where(id: items_with_bookings.map(&:vehicle_route_schedule_id))
        .index_by(&:id)

      Spot.transaction do
        # record transaction
        company = Current.company
        company.lock!

        total_credits = company.credits.sum(:amount)

        if total_credits < total_booking_cost
          raise InsufficentCredits, "Insufficient funds"
        end

        # create campaign
        sorted_bookings = items_with_bookings.sort_by(&:etd)
        campaign = Current.company.campaigns.create!(
          name: @campaign_name,
          start_date: sorted_bookings.first.etd.to_date,
          end_date: sorted_bookings.last.etd.to_date,
          advertiser: Current.user
        )

        company
          .credits
          .spend!(campaign, total_booking_cost, Current.user,
            "Booked spots for campaign #{@campaign_name}"
          )

        # book spots
        items_with_bookings.each do |booking_item|
          vehicle_schedule = vehicle_schedule_index[booking_item.vehicle_route_schedule_id.to_i]

          time_slot = vehicle_schedule.time_slot

          [Spot.types.regular, Spot.types.premium].each do |spot_type|
            next unless booking_item.has_bookings_for?(spot_type)

            booked_spots  = spot_type == Spot.types.regular ?
              booking_item.booked_regular_spots :
              booking_item.booked_premium_spots

            actual_booked = time_slot.update_available_spots(
              spot_type,
              booked_spots.to_i
            )

            if actual_booked == 0
              raise SpotUnavailable, ("No more available %s spots" % spot_type)
            end

            campaign.spots.create!(
              time_slot: time_slot,
              type: spot_type,
              vehicle_route_schedule: vehicle_schedule,
              route: vehicle_schedule.route,
              creator: Current.user,
              count: actual_booked,
              cost_per_cpm: Spot.cpms[spot_type],
            )
          end
        end
      end
    end
end
