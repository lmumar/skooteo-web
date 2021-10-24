# frozen_string_literal: true

namespace :reporting do
  desc "extract video play logs"
  task extract_video_play_logs: :environment do
    TripLog
      .ready
      .find_in_batches do |trip_logs|
        ReportingServices::VideoPlayLogExtractor.extract(trip_logs)
      end
    puts "done."
  end
end
