# frozen_string_literal: true

module Queries
  class FleetOperators < BaseQuery
    argument :query, String, required: false
    argument :offset, Integer, required: false
    argument :limit, Integer, required: false

    type [Types::CompanyType], null: true

    def resolve(query: '', offset: 0, limit: DEFAULT_LIMIT)
      fleets = ::Company.order('name')
      if query.present?
        fleets = fleets.where('lower(name) like ?', ['%', query.downcase, '%'].join)
      end
      fleets.limit(limit).offset(offset)
    end
  end
end
