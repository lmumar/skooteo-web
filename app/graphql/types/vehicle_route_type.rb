# frozen_string_literal: true

module Types
  class VehicleRouteType < BaseObject
    field :id, ID, null: false
    field :vehicle, Types::VehicleType, null: false
    field :route, Types::RouteType, null: false
    field :first_half_distance, Float, null: false

    field :estimated_travel_duration_in_minutes, Float, null: false
    field :time_allotted_for_regular_ads_in_minutes, Float, null: false
    field :time_allotted_for_premium_ads_in_minutes, Float, null: false
    field :regular_ads_segment_length_in_minutes, Float, null: false
    field :premium_ads_segment_length_in_minutes, Float, null: false
    field :time_allotted_for_onboarding_in_minutes, Float, null: false
    field :time_allotted_for_offboarding_in_minutes, Float, null: false
    field :arrival_trigger_in_minutes, Float, null: false

    field :eta_sampler_trigger_in_minutes, Float, null: false
    field :trip_end_buffer_in_minutes, Float, null: false

    def vehicle
      RecordLoader.for(Vehicle).load(object.vehicle_id)
    end

    def route
      RecordLoader.for(Route).load(object.route_id)
    end

    def first_half_distance
      route.then { |r| r.first_half_distance.value }
    end

    def estimated_travel_duration_in_minutes
      object.estimated_travel_duration.in_minutes
    end

    def time_allotted_for_regular_ads_in_minutes
      object.regular_ads_duration.in_minutes
    end

    def time_allotted_for_premium_ads_in_minutes
      object.premium_ads_duration.in_minutes
    end

    def regular_ads_segment_length_in_minutes
      object.regular_ads_segment_duration.in_minutes
    end

    def premium_ads_segment_length_in_minutes
      object.premium_ads_segment_duration.in_minutes
    end

    def time_allotted_for_onboarding_in_minutes
      object.onboarding_duration.in_minutes
    end

    def time_allotted_for_offboarding_in_minutes
      object.offboarding_duration.in_minutes
    end

    def arrival_trigger_in_minutes
      object.arrival_trigger_duration.in_minutes
    end

    def eta_sampler_trigger_in_minutes
      setting_for :eta_sampler_trigger_in_minutes
    end

    def trip_end_buffer_in_minutes
      setting_for :trip_end_buffer_in_minutes
    end

    private
      def setting_for(key)
        Rails.application.config_for(:globals).fetch(key)
      end
  end
end
