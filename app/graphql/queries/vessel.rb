# frozen_string_literal: true

module Queries
  class Vessel < BaseQuery
    argument :id, ID, required: true

    type Types::VesselType, null: true

    def resolve(id:)
      ::Vessel.find_by(id: id)
    end
  end
end
