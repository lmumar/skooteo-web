# frozen_string_literal: true

require 'csv'

module Admin
  module Companies
    class VideoPlayLogsController < Admin::BaseController
      before_action :set_company

      def create
        start_date = Time.zone.parse(params[:start_date])
        end_date   = Time.zone.parse(params[:end_date])
        service = ReportingServices::VideoPlaytimes.new(@company, start_date, end_date)
        csv_string = CSV.generate do |csv|
          csv << [
            'trip date',
            'route',
            'vessel',
            'etd',
            'eta',
            'time delivered',
            'longitude',
            'latitude',
            'video name',
            'duration in secs',
            'actual_etd',
            'actual_eta'
          ]
          service.each_csv_row do |row|
            csv << row
          end
        end
        send_data(csv_string, type: 'text/csv; charset=utf-8; header=present', filename: 'video_playlogs.csv')
      end

      private

      def set_company
        @company ||= Company.find params[:company_id]
      end
    end
  end
end
