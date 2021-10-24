# frozen_string_literal: true

module ReportingServices
  module VideoPlayLogExtractor
    module_function

    TRIP_COMPLETED = 2

    def extract(trip_logs)
      trip_logs.each do |trip_log|
        next unless trip_log.trip_info['status'] == TRIP_COMPLETED # status should be complete to proceed
        if trip_log.time_slot.present?
          process_advideo_logs(trip_log)
        end
        process_entvideo_logs(trip_log)
        trip_log.status_details = nil
        trip_log.processed!
      rescue => e
        puts "[!] Error processing trip log with id #{trip_log.id}, err: #{e.message}"
        trip_log.status_details = e.message
        trip_log.error!
        next
      end
    end

    def process_advideo_logs(trip_log)
      trip_log
        .video_info
        .select { |vplay_info|
          vplay_info['notes'] == 'delivered' && vplay_info['video_type'] == 'advertisement'
        }
        .each do |vplay_info|
          playseq = PlaySequence.find_by(
            vehicle_id: trip_log.trip_info['vessel_id'],
            time_slot_id: trip_log.time_slot_id
          )
          segment_type = vplay_info['segment_type'] == 'regular' ? 'RegularSpot' : 'PremiumSpot'
          playvids = playseq.play_sequence_videos.where(segment_type: segment_type)
          seggroup = playvids.group_by(&:segment)
          segs = []
          seggroup.keys.sort.each do |i|
            psvs = seggroup[i].sort { |a, b| a.segment_order <=> b.segment_order }
            segs << psvs
          end
          playvid = segs[vplay_info['segment_position'].to_i][vplay_info['video_position_in_segment'].to_i]
          unless playvid.video_id != vplay_info['video_id'].to_i
            playvid = segs[vplay_info['segment_position'].to_i].detect { |record|
              record.video_id == vplay_info['video_id'].to_i
            }
          end
          create_video_play_log(
            trip_log,
            vplay_info,
            vplay_info['segment_position'],
            vplay_info['video_position_in_segment'],
            playseq,
            playvid
          )
        end
    end

    def process_entvideo_logs(trip_log)
      time_frame = get_entertainment_time_frame(trip_log.trip_info["date"], trip_log.trip_info["vessel_id"])
      trip_log
        .video_info
        .select { |vplay_info| vplay_info['notes'] == 'delivered' }
        .reject { |vplay_info| vplay_info['video_type'] == 'advertisement' }
        .each { |vplay_info|
          start_time = parse_datetime(trip_log.trip_info["date"], time_frame[:start]) - 30.minutes
          end_time = parse_datetime(trip_log.trip_info["date"], time_frame[:end]) + 60.minutes
          vplay_info_start_time = parse_datetime(trip_log.trip_info["date"], vplay_info['start'])

          next unless vplay_info_start_time > start_time && vplay_info_start_time < end_time

          create_video_play_log(
            trip_log,
            vplay_info,
            vplay_info['segment_position'],
            vplay_info['video_position_in_segment']
          )
        }
    end

    def parse_datetime(sdate, stime)
      return nil if sdate.nil? || stime.nil?
      sdttime = [sdate, stime].join(' ')
      Time.zone.parse(sdttime)
    end

    def get_entertainment_time_frame(date, vehicle_id)
      trips = TripLog.where("trip_info ->> 'date' = ?", date).where(vehicle_id: vehicle_id).order("trip_info->>'etd'")
      return { "start": trips[0].trip_info["etd"], "end": trips[trips.length - 1].trip_info["eta"] }
    end

    def create_video_play_log(trip_log, vplay_info, segment, segment_pos, playseq = nil, playvid = nil)
      trip_info = trip_log.trip_info
      record = VideoPlayLog.find_or_initialize_by(
        trip_log_id: trip_log.id,
        vehicle_id: trip_info['vessel_id'],
        video_id: vplay_info['video_id'],
        report_id: vplay_info['report_id']
      )
      record.time_slot_id   = trip_log.time_slot_id
      record.spot_id        = playvid&.spot&.id
      record.campaign_id    = playvid&.spot&.campaign_id
      record.play_start = parse_datetime(trip_info['date'], vplay_info['start'])
      record.play_end = parse_datetime(trip_info['date'], vplay_info['end'])
      record.segment        = segment
      record.segment_order  = segment_pos
      record.video_type     = vplay_info['video_type']
      record.trip_etd       = parse_datetime(trip_info['date'], trip_info['etd'])
      record.trip_eta       = parse_datetime(trip_info['date'], trip_info['eta'])
      lonlat = vplay_info['coordinates'] || {}
      if lonlat['lat'].present? && lonlat['lng'].present?
        record.lonlat = "POINT(#{lonlat['lng']} #{lonlat['lat']})"
      end
      record.save!
    end
  end
end
