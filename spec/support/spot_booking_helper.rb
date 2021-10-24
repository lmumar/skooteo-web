# frozen_string_literal: true

module SpotBookingHelper
  def build_spot(campaign_name:, vehicle_route_schedule:, premium_spots: 0, regular_spots: 0)
    spot_booking = ::Spot::Booking.new(campaign_name: campaign_name)

    spot_booking_item = ::Spot::BookingItem.from(vehicle_route_schedule: vehicle_route_schedule)
    spot_booking_item.booked_regular_spots = regular_spots
    spot_booking_item.booked_premium_spots = premium_spots
    spot_booking << spot_booking_item

    spot_booking.calculate
    spot_booking
  end
end

RSpec.configure do |config|
  config.include SpotBookingHelper
end
