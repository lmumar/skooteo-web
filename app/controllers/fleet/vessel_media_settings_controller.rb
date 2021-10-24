# frozen_string_literal: true

module Fleet
  class VesselMediaSettingsController < BaseController
    before_action :set_route, only: %i[ edit ]
    before_action :set_vessel, only: %i[ edit ]
    before_action :set_vessel_route, only: %i[ save ]

    def edit
      VehicleRoute.ensure_unique_existence!(@vessel, @route)
      @vessel_route = Current.company.vehicle_routes.find_by(route: @route, vehicle: @vessel)
    end

    def save
      @vessel_route.update_from_params(route_params.to_h.deep_symbolize_keys)
    end

    private
      def route_params
        params
          .require(:vessel_route)
          .permit(
            ett: {}, onboarding: {}, offboarding: {},
            arrival_trigger: {}, regular_ads: {}, premium_ads: {},
            regular_ads_segment: {}, premium_ads_segment: {}
          )
      end

      def set_route
        @route = Current.company.routes.find(params[:route_id])
      end

      def set_vessel
        @vessel = Current.company.vessels.find(params[:vessel_id])
      end

      def set_vessel_route
        @vessel_route = Current.company.vehicle_routes.find(params[:id])
      end
  end
end
