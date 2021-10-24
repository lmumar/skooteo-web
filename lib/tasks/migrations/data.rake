# frozen_string_literal: true

namespace :migrations do
  desc 'Skooteo | Update existing trip log missing info'
  task 'data:update_trip_logs' => :environment do
    Time.zone = "Asia/Manila"
    TripLog.where(trip_etd: nil).each do |record|
      next unless record.trip_info
      trip_info = record.trip_info
      etd = Time.zone.parse([trip_info['date'], trip_info['etd']].join(' ')).utc
      eta = Time.zone.parse([trip_info['date'], trip_info['eta']].join(' ')).utc
      record.trip_etd = etd
      record.trip_eta = eta
      record.vehicle_id = trip_info['vessel_id']
      record.save!
    end
  end

  desc 'Skooteo | Onetime fix reports'
  task 'data:update_trip_info' => :environment do
    TripLog.all.each do |record|
      record["video_info"].each do |vinfo|
        next unless vinfo["video_type"] == "advertisement" && \
          record["trip_info"]["segments"]["regular"][vinfo["segment_position"]][vinfo["video_position_in_segment"]] == nil
        record["trip_info"]["segments"]["regular"][vinfo["segment_position"]][vinfo["video_position_in_segment"]] = vinfo["video_id"]
        record.save!
      end
    end
  end
end
