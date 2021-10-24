# frozen_string_literal: true

module Fleet
  class VesselSchedulesController < BaseController
    before_action :set_route
    before_action :set_schedules

    def index
    end

    private
      def set_route
        @route = params[:route_id].present? ? Current.company.routes.find(params[:route_id]) : nil
      end

      def set_schedules
        @period = [
          params.dig(:date, :year) || Date.today.year,
          (params.dig(:date, :month) || Date.today.month).to_s.rjust(2, '0'),
          '01'
        ].join('-')
        @period = @period.to_date
        @vessel_schedules = VehicleRouteSchedule.results(filters: {
          inactive: '0',
          route: @route,
          company_ids: [Current.company.id],
          period: {
            mm: @period.month,
            yyyy: @period.year
          }
        }).includes(:vehicle, :route).order('etd desc')
      end
  end
end
