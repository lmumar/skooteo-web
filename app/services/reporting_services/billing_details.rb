# frozen_string_literal: true

module ReportingServices
  class BillingDetails
    def initialize(company, start_date, end_date)
      @company    = company
      @start_date = start_date
      @end_date   = end_date
    end

    def each_csv_row(&block)
      vidlogs = load_video_playlogs
      vidlogs.each do |vidlog|
        yield [
          vidlog.time_slot.etd.strftime('%d-%b-%Y'),
          vidlog.time_slot.route.name,
          vidlog.vehicle.company.name,
          vidlog.vehicle.name,
          vidlog.time_slot.etd.strftime('%I:%M %p'),
          vidlog.time_slot.eta.strftime('%I:%M %p'),
          vidlog.play_start.strftime('%I:%M:%S %p'),
          vidlog.lonlat&.lon&.floor(5) || '',
          vidlog.lonlat&.lat&.floor(5) || '',
          vidlog.video.company.name,
          vidlog&.campaign&.name || '',
          vidlog.video.name,
          vidlog.video.duration_in_seconds,
          vidlog.video.consumable_spot_count,
          vidlog.trip_log&.trip_info&.dig('atd'),
          vidlog.trip_log&.trip_info&.dig('ata')
        ]
      end
    end

    private

    def load_video_playlogs
      VideoPlayLog
        .includes(
          :vehicle,
          :company,
          :video,
          :campaign,
          :spot,
          time_slot: :route
        )
        .where.not(video_play_logs: { time_slot_id: nil })
        .where(companies: { id: @company.id })
        .where('trip_etd between ? and ?', @start_date, @end_date)
        .order('trip_etd')
    end
  end
end
