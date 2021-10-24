# frozen_string_literal: true

class Spot::BookingItem
  using Skooteo::Patch::Number

  extend ActiveModel::Naming

  VALID_ATTRIBUTE_KEYS = [
    :vehicle_route_schedule_id,
    :vehicle_route_id,
    :company,
    :route_id,
    :route_name,
    :vehicle_name,
    :vehicle_type,
    :etd,
    :eta,
    :available_regular_spots,
    :available_premium_spots,
    :booked_regular_spots,
    :booked_premium_spots,
    :passenger_capacity,
    :credits_per_spot
  ]

  VALID_ATTRIBUTE_KEYS.each { |attr|
    attr_accessor attr.to_sym
  }

  attr_reader :errors

  class << self
    def from(vehicle_route_schedule:)
      new(
        company: vehicle_route_schedule.company.name,
        vehicle_route_schedule_id: vehicle_route_schedule.id,
        vehicle_route_id: vehicle_route_schedule.vehicle_route_id,
        vehicle_type: vehicle_route_schedule.vehicle.vehicleable.kind,
        route_id: vehicle_route_schedule.route_id,
        route_name: vehicle_route_schedule.route.name,
        vehicle_name: vehicle_route_schedule.vehicle.name,
        etd: vehicle_route_schedule.etd,
        eta: vehicle_route_schedule.eta,
        available_regular_spots: vehicle_route_schedule.time_slot.available_regular_spots,
        available_premium_spots: vehicle_route_schedule.time_slot.available_premium_spots,
        booked_regular_spots: nil,
        booked_premium_spots: nil,
        passenger_capacity: vehicle_route_schedule.vehicle.capacity,
        credits_per_spot: vehicle_route_schedule.vehicle.credits_per_spot
      )
    end

    def bulk_clone(booking_items, ndays, interval)
      with_bookings = booking_items.select(&:has_bookings?)
      return [] if with_bookings.empty?
      booking_index = with_bookings.group_by { |item| item.vehicle_route_id.to_i }

      starting_etd = with_bookings.first.etd
      ending_etd   = starting_etd.advance(days: interval * ndays)

      # pre-compute valid etd base on interval. So if starting date is Jan 1, ending date is Jan 15
      # with interval set to 7, this will return the dates Jan 1, Jan 8 and Jan 15
      valid_etds = (starting_etd.to_date..ending_etd.to_date)
        .each_with_index
        .select { |_, i| i % interval == 0 }
        .map { |date, i| date }

      vessel_routes = VehicleRoute.where(id: booking_index.keys)

      route_schedules = VehicleRouteSchedule.search(
        scope: VehicleRouteSchedule.includes(:time_slot),
        filters: {
          etd_between: { date1: starting_etd, date2: ending_etd },
          vehicle_route: vessel_routes,
          sort: 'etd',
        }
      ).results.where.not(time_slots: { id: nil })

      # filter only those schedules that matches the pre-computed valid_etds
      route_schedules = route_schedules.select { |record| valid_etds.include?(record.etd.to_date) }

      # remove schedules that matches the booked schedule etds
      route_schedules = route_schedules.reject { |record| record.etd == starting_etd }

      route_schedules.inject([]) do |new_booking_items, record|
        booking_items = booking_index[record.vehicle_route_id] || []
        booking_item  = booking_items.detect { |item|
          [item.etd.hour, item.etd.min] == [record.etd.hour, record.etd.min]
        }

        if booking_item
          new_item = booking_item.clone
          new_item.vehicle_route_schedule_id = record.id
          new_item.etd = record.etd
          new_item.eta = record.eta

          if new_item.has_regular_bookings?
            new_item.booked_regular_spots = [new_item.booked_regular_spots.to_i, record.time_slot.available_regular_spots].min
          end

          if new_item.has_premium_bookings?
            new_item.booked_premium_spots = [new_item.booked_premium_spots.to_i, record.time_slot.available_premium_spots].min
          end

          new_booking_items << new_item
        end

        new_booking_items
      end
    end
  end

  def initialize(attrs = {})
    VALID_ATTRIBUTE_KEYS.each { |attr|
      self.send "#{attr}=".to_sym, attrs[attr]
    }

    self.etd = Time.zone.parse(self.etd) if self.etd.is_a?(String)
    self.eta = Time.zone.parse(self.eta) if self.eta.is_a?(String)

    @errors = ActiveModel::Errors.new(self)
  end

  def has_bookings?
    has_premium_bookings? || has_regular_bookings?
  end

  def has_bookings_for?(spot_type)
    unless Spot.types.all.include?(spot_type)
      raise UnknownArgumentError, 'Invalid spot type'
    end
    send(['has', spot_type, 'bookings?'].join('_').to_sym)
  end

  def has_premium_bookings?
    (self.booked_premium_spots.present? && self.booked_premium_spots.to_i > 0)
  end

  def has_regular_bookings?
    (self.booked_regular_spots.present? && self.booked_regular_spots.to_i > 0)
  end

  def regular_booking_cost
    credits_per_spot = self.credits_per_spot.to_f
    Spot.compute_booking_cost(
      self.booked_regular_spots&.to_i || 0,
      credits_per_spot
    )
  end

  def premium_booking_cost
    credits_per_spot = self.credits_per_spot.to_f
    Spot.compute_booking_cost(
      self.booked_premium_spots&.to_i || 0,
      credits_per_spot
    )
  end

  def booking_cost
    (regular_booking_cost + premium_booking_cost).skstd_round
  end
end
