# frozen_string_literal: true

class TimeSlot < ApplicationRecord
  has_many :spots
  has_many :playlists, through: :spots

  belongs_to :vehicle
  belongs_to :company
  belongs_to :vehicle_route_schedule
  belongs_to :route

  has_one :vehicle_route, through: :vehicle_route_schedule

  validate :validate_spots, on: :create

  scope :sequenceable, ->(reftime = 1.minute.since(Time.now)) {
    joins(:vehicle_route_schedule).where('vehicle_route_schedules.etd > ?', reftime)
  }

  TYPE_TO_FIELD = {
    Spot.types.regular => :available_regular_spots,
    Spot.types.premium => :available_premium_spots,
  }
  def update_available_spots(spot_type, total_booked)
    actual_booked = total_booked
    loop do
      available_field = TYPE_TO_FIELD.fetch(spot_type)
      available_spots = read_attribute(available_field.to_sym)

      if available_spots <= 0
        actual_booked = 0
        break
      end

      actual_booked = [actual_booked, available_spots].min
      updated_count = TimeSlot
        .where(id: self.id, available_field => available_spots)
        .update_all(available_field => available_spots - actual_booked)

      # reload current time slot to load new available counts
      reload

      # time slot updated, let's break
      break if updated_count > 0
    end

    actual_booked
  end

  private
    def validate_spots
      if available_regular_spots <= 0 && available_premium_spots <= 0
        errors.add(:base, :invalid, message: 'spot availability should be specified')
      end
    end
end
