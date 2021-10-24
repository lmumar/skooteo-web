# frozen_string_literal: true
require 'csv'

module Admin
  module Companies
    class BillingDetailsController < Admin::BaseController
      before_action :set_company

      def create
        start_date = Time.zone.parse(params[:start_date]).beginning_of_day
        end_date   = Time.zone.parse(params[:end_date]).end_of_day
        service = ReportingServices::BillingDetails.new(@company, start_date, end_date)
        csv_string = CSV.generate do |csv|
          csv << [
            'trip date',
            'route',
            'fleet operator',
            'vessel name',
            'etd',
            'eta',
            'time delivered',
            'longitude',
            'latitude',
            'advertiser',
            'campaign',
            'video name',
            'duration in secs',
            'spots consumed',
            'atd',
            'ata'
          ]
          service.each_csv_row do |row|
            csv << row
          end
        end
        send_data(csv_string, type: 'text/csv; charset=utf-8; header=present', filename: 'billing_details.csv')
      end

      private

      def set_company
        @company ||= Company.find params[:company_id]
      end
    end
  end
end
