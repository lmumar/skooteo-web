# frozen_string_literal: true

module Queries
  class Trip < BaseQuery
    argument :id, ID, required: true

    type Types::TripType, null: true

    def resolve(id:)
      VehicleRouteSchedule.find_by(id: id)
    end
  end
end
