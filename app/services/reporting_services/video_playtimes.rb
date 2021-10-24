# frozen_string_literal: true

module ReportingServices
  class VideoPlaytimes
    def initialize(company, start_date, end_date)
      @company    = company
      @start_date = start_date
      @end_date   = end_date
    end

    def each_csv_row(&block)
      vidlogs = load_video_playlogs
      vidlogs.each do |vidlog|
        route = determine_route(vidlog)
        yield [
          vidlog.trip_etd.strftime('%d-%b-%Y'),
          route&.name || '',
          vidlog.vehicle.name,
          vidlog.trip_etd.strftime('%I:%M %p'),
          vidlog.trip_eta.strftime('%I:%M %p'),
          vidlog.play_start.strftime('%I:%M:%S %p'),
          vidlog.lonlat&.lon&.floor(5) || '',
          vidlog.lonlat&.lat&.floor(5) || '',
          vidlog.video.name,
          vidlog.play_end - vidlog.play_start,
          vidlog.trip_log&.trip_info&.dig('atd'),
          vidlog.trip_log&.trip_info&.dig('ata'),
        ]
      end
    end

    private

    def load_video_playlogs
      VideoPlayLog
        .includes(
          :company,
          :video,
          :trip_log,
          vehicle: :vehicle_route_schedules,
        )
        .where(video_type: Skooteo::ENTERTAINMENT_VIDEO_TYPE)
        .where(vehicle_id: @company.vehicle_ids)
        .where('video_play_logs.trip_etd between ? and ?', @start_date, @end_date)
        .order('video_play_logs.play_start')
    end

    def determine_route(vidlog)
      (vidlog.trip_log&.trip_info && Route.find(vidlog.trip_log.trip_info['route_id'])) || nil
    end
  end
end
