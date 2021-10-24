# frozen_string_literal: true

module Types
  class TripType < BaseObject
    field :id, ID, null: false
    field :etd, String, null: false
    field :eta, String, null: false
    field :status, Integer, null: false
    field :status_text, String, null: true
    field :route, Types::RouteType, null: false
    field :vehicle_route, Types::VehicleRouteType, null: false

    def etd
      object.etd.utc
    end

    def eta
      object.eta.utc
    end

    def route
      load_association :route
    end

    def vehicle_route
      load_association :vehicle_route
    end
  end
end
