# frozen_string_literal: true

module Fleet
  class VesselRouteSchedulesController < ::Fleet::BaseController
    before_action :set_vessel, :set_route, except: %w(edit show activate deactivate)
    before_action :set_vessel_route, only: %w(new_schedule index create)
    before_action :set_vessel_schedule, only: %w(edit activate deactivate)

    def index
      @period = [
        params[:yyyy] || Date.today.year,
        (params[:mm] || Date.today.month).to_s.rjust(2, '0'),
        '01'
      ].join('-')
      @period = @period.to_date
      @vessel_schedules = VehicleRouteSchedule.results(filters: {
        vehicle_route: @vessel_route,
        inactive: params[:inactive],
        period: {
          mm: @period.month,
          yyyy: @period.year
        }
      })
    end

    def new_schedule
      @vessel_schedule = VehicleRouteSchedule.new
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(:new_schedule_template, partial: 'new')
        end
        format.html {
          redirect_to fleet_vessels_path
        }
      end
    end

    def create
      @vehicle_schedule_template = VehicleRouteSchedule::Template.new(vehicle_schedule_template)
      @vehicle_schedule_template.create_schedules!(@vessel_route)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            :new_schedule_template,
            %Q(<tr class="is-hidden" id="new_schedule_template" />)
          )
        end
      end
    end

    def activate
      if @vessel_schedule.inactive?
        # NOTE: when debugging the history of activation/deactivation
        # check the event's table
        @vessel_schedule.status_text = nil
        @vessel_schedule.active!
      end
      @vessel_schedule.broadcast_remove_to 'fleet:schedules'
      respond_to do |format|
        format.any do
          head :ok
        end
      end
    end

    def deactivate
      if @vessel_schedule.active?
        @vessel_schedule.status_text = params[:value]
        @vessel_schedule.inactive!
        # TODO: remove all spots and refund customer credits
      end
      @vessel_schedule.broadcast_remove_to 'fleet:schedules'
      respond_to do |format|
        format.any do
          head :ok
        end
      end
    end

    private
      def set_vessel
        @vessel = Current.company.vehicles.find(params[:vessel_id])
      end

      def set_route
        @route = Current.company.routes.find(params[:route_id])
      end

      def set_vessel_route
        @vessel_route = Current.company.vehicle_routes.find_by(
          vehicle_id: params[:vessel_id],
          route_id: params[:route_id]
        )
      end

      def set_vessel_schedule
        @vessel_schedule = VehicleRouteSchedule.unscoped.find params[:id]
        @route = @vessel_schedule.route
        @vessel = @vessel_schedule.vehicle
      end

      def vehicle_schedule_template
        params.require(:vehicle_schedule_template)
          .permit(:effective_start_date, :effective_end_date, :td, days: {})
      end
  end
end
