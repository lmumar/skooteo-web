# frozen_string_literal: true

module Fleet
  class VesselRoutesController < BaseController
    skip_before_action :require_fleet_operator!, only: %w(index)

    before_action :set_vessel, except: %w(index)
    before_action :set_routes, only: %w(index)
    before_action :set_route, only: %w(edit update destroy)

    def index
      @route = @routes.results.first
      respond_to do |format|
        format.html do
          set_vessel
          render layout: false
        end
        format.json { render json: @routes.results }
      end
    end

    def new
      @route = Route.new
      render action: :edit
    end

    def edit
    end

    def create
      @route = Current.company.routes.create!(normalize_params)
      set_routes
    end

    def update
      @route.transaction do
        @route.waypoints.destroy_all
        @route.update!(normalize_params)
      end
    end

    private
      def set_routes
        @routes ||=
          Route.search(
            filters: {
               company_ids: get_company_scope,
               query: params[:q]
            },
            page: params[:page] || 1,
            per_page: params[:per_page] || 100
          )
      end

      def get_company_scope
        params[:company_ids] || Current.company.id
      end

      def set_vessel
        @vessel = Current.company.vehicles.find(params[:vessel_id])
      end

      def set_route
        @route = Current.company.routes.find params[:id]
      end

      def normalize_params
        route_attributes = route_params.to_h
        distances = route_attributes.extract!('distance_in_km', 'first_half_distance_in_km')
        hash = route_attributes.merge({
          'distance' => MetricDistance.from_km(distances['distance_in_km']),
          'first_half_distance' => MetricDistance.from_km(distances['first_half_distance_in_km'])
        })
      end

      def route_params
        params
          .require(:route)
          .permit(
            :name,
            :first_half_distance_in_km,
            :distance_in_km,
            waypoints_attributes: [:name, :sequence, :coordinates])
      end
  end
end
