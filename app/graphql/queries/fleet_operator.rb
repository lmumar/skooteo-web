# frozen_string_literal: true

module Queries
  class FleetOperator < BaseQuery
    argument :id, ID, required: true

    type Types::CompanyType, null: true

    def resolve(id:)
      ::Company.fleet_operator.find_by(id: id)
    end
  end
end
