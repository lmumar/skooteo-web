# frozen_string_literal: true

module Types
  class RouteType < BaseObject
    implements CompanyOwnable

    field :id, ID, null: false
    field :name, String, null: false
    field :first_half_distance, Float, null: false
    field :distance, Float, null: false
    field :origin, String, null: false
    field :destination, String, null: false
    field :waypoints, [Types::WaypointType], null: false

    # deprecated fields, this information should be taken from
    # the vehicle route & vehicle route media setting
    field :estimated_travel_duration_in_minutes, Float, null: false
    field :time_allotted_for_regular_ads_in_minutes, Float, null: false
    field :time_allotted_for_premium_ads_in_minutes, Float, null: false
    field :regular_ads_segment_length_in_minutes, Float, null: false
    field :premium_ads_segment_length_in_minutes, Float, null: false

    def distance
      object.distance.value
    end

    def first_half_distance
      object.first_half_distance.value
    end

    def waypoints
      load_association :waypoints
    end

    # deprecated fields, this information should be taken from
    # the vehicle route & vehicle route media setting
    def estimated_travel_duration_in_minutes
      load_vehicle_routes.then { |vehicle_routes|
        vehicle_routes.first&.estimated_travel_duration&.in_minutes
      }
    end

    def time_allotted_for_regular_ads_in_minutes
      load_vehicle_routes.then { |vehicle_routes|
        vehicle_routes.first&.regular_ads_duration&.in_minutes
      }
    end

    def time_allotted_for_premium_ads_in_minutes
      load_vehicle_routes.then { |vehicle_routes|
        vehicle_routes.first&.premium_ads_duration&.in_minutes
      }
    end

    def regular_ads_segment_length_in_minutes
      load_vehicle_routes.then { |vehicle_routes|
        vehicle_routes.first&.regular_ads_segment_duration&.in_minutes
      }
    end

    def premium_ads_segment_length_in_minutes
      load_vehicle_routes.then { |vehicle_routes|
        vehicle_routes.first&.premium_ads_segment_duration&.in_minutes
      }
    end

    def load_vehicle_routes
      load_association :vehicle_routes
    end
  end
end
