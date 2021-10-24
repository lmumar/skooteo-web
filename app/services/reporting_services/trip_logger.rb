# frozen_string_literal: true

module ReportingServices
  module TripLogger
    module_function

    def save(trip_log_attributes)
      record = find_or_initialize_trip_log(trip_log_attributes)
      record.video_info = JSON.parse(trip_log_attributes.video_info) if trip_log_attributes.video_info.present?
      record.video_info ? record.ready! : record.save!
      record
    end

    def parse_datetime(sdate, stime)
      return nil if sdate.nil? || stime.nil?
      sdttime = [sdate, stime].join(' ')
      Time.zone.parse(sdttime)
    end

    def find_or_initialize_trip_log(trip_log_attributes)
      trip_info = JSON.parse(trip_log_attributes.trip_info)

      etd = parse_datetime(trip_info['date'], trip_info.fetch('etd'))
      eta = parse_datetime(trip_info['date'], trip_info.fetch('eta'))

      record = if trip_log_attributes.time_slot_id.present? && trip_log_attributes.time_slot_id.to_i > 0
        TripLog.find_or_initialize_by(
          time_slot_id: trip_log_attributes.time_slot_id
        ).tap { |log|
          log.trip_etd = etd
          log.vehicle_id = trip_info.fetch('vessel_id')
        }
      else
        TripLog.find_or_initialize_by(
          vehicle_id: trip_info.fetch('vessel_id'),
          trip_etd: etd
        )
      end

      record.trip_eta = eta
      record.trip_info = trip_info
      record
    end
  end
end
