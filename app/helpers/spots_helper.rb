# frozen_string_literal: true

module SpotsHelper
  def clone_xdays_options(start_date)
    ['Days', format_day_of_week(start_date)]
  end

  def media_spots_path_from_booking_state(booking)
    booking.calculated? ? media_spots_path : calculate_media_spots_path
  end
end
