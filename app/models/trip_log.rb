# frozen_string_literal: true

class TripLog < ApplicationRecord
  belongs_to :time_slot, optional: true

  # statuses:
  #   pending   - missing video_info or trip_info or both
  #   ready     - video_info and trip_info are present ready for further processing
  #   processed - video_play_logs were generated from the trip log info
  #   error     - error during data collection or processing step
  #   settled   - refund processing completed successfully
  enum status: [ :pending, :ready, :processed, :error, :settled ]

  validates :trip_etd, :vehicle_id, presence: true
end
