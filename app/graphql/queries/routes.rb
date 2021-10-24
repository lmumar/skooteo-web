# frozen_string_literal: true

module Queries
  class Routes < BaseQuery
    description "Find routes"

    argument :ids, [ID], required: true
    type [Types::RouteType], null: false

    def resolve(ids:)
      Route.where(id: ids)
    end
  end
end
