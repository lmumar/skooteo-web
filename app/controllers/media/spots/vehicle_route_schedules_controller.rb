# frozen_string_literal: true

module Media
  class Spots::VehicleRouteSchedulesController < BaseController
    before_action :set_route_schedules, only: %w(search)
    before_action :set_route_spots, only: %w(search)

    def search
      respond_to do |format|
        format.html
        format.turbo_stream {
          render turbo_stream: turbo_stream.update(
            'route-search-results',
            partial: 'vehicle_route_schedule',
            locals: { route_schedules: @route_schedules }
          )
        }
      end
    end

    private
      def set_route_schedules
        date1       = params[:start_date].to_time
        date2       = date1.end_of_day
        company_ids = params[:companies].select(&:present?)
        company_ids = company_ids.empty? ?
          Company.results.pluck(:id) :
          company_ids

        filters = {
          company_ids: company_ids,
          destination: params[:destination],
          origin: params[:origin],
          etd_between: {
            date1: date1,
            date2: date2
          }
        }.compact

        @route_schedules = VehicleRouteSchedule.results(
          scope: VehicleRouteSchedule.spot_bookable.includes(:time_slot),
          filters: filters
        )
      end

      def set_route_spots
        hsh = Hash.new { |h, key| h[key] = { regular: 0, premium: 0 } }
        @route_spots = @route_schedules.inject(hsh) do |dict, record|
          dict[record.route_id][:regular] += record.time_slot.available_regular_spots
          dict[record.route_id][:premium] += record.time_slot.available_premium_spots
          dict
        end
      end
  end
end
