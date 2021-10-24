# frozen_string_literal: true

module Queries
  class Vessels < BaseQuery
    argument :company_id, ID, required: true
    argument :query, String, required: false
    argument :offset, Integer, required: false
    argument :limit, Integer, required: false

    type [Types::VesselType], null: true

    def resolve(company_id: , query: '', offset: 0, limit: DEFAULT_LIMIT)
      vs = ::Vessel.eager_load(:vehicle).order('vehicles.name')
        .where('vehicles.company_id = ?', company_id)
      if query.present?
        vs = vs.where('lower(vehicles.name) like ?', ['%', query.downcase, '%'].join)
      end
      vs.limit(limit).offset(offset)
    end
  end
end
