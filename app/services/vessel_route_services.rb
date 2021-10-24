module VesselRouteServices
  class Registration
    attr_reader :route
    attr_reader :route_params

    def initialize route_params
      @route_params = route_params
    end

    def call
      Route.transaction do
        @route = VesselRoute.new route_params
        @route.company = Current.company
        @route.creator_id = 1
        @route.creator = Current.user
        @route.save!
      end
      @route
    end
  end

  class Updates
    def initialize route, route_params
      @route_params = route_params
      @route = route
    end

    def call
      Route.transaction do
        @route.waypoints.destroy_all
        @route.update_attributes! @route_params
      end
    end
  end

  class BoardingDurationUpdate

    def initialize(options = {})
      @vessel_route_id = options[:id]
      @vessel_route = options[:object]
    end

    def call
      route = @vessel_route || VehicleRoute.find_by_id(@vessel_route_id)
      return unless route

      Rails.logger.info {
        "[i] computing on/offboarding duration for vehicle route #{route.id}"
      }

      onboarding = route.company.playlists.default.onboarding
      offboarding = route.company.playlists.default.offboarding

      total_onboarding_duration = onboarding.sum(&:total_duration_in_minutes)
      total_offboarding_duration = offboarding.sum(&:total_duration_in_minutes)

      route.time_allotted_for_onboarding_in_minutes = total_onboarding_duration
      route.time_allotted_for_offboarding_in_minutes = total_offboarding_duration
      route.disable_auto_sequencing = true
      route.save!
    end
  end
end
