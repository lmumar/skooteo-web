# frozen_string_literal: true

module Queries
  class Trips < BaseQuery
    argument :vehicle_id, ID, required: true
    argument :start_date, String, required: false
    argument :end_date, String, required: false

    type [Types::TripType], null: false

    def resolve(vehicle_id:, start_date: nil, end_date: nil)
      s_date = start_date.nil? ? Time.current.beginning_of_day :
        Time.zone.parse(start_date).beginning_of_day

      e_date = end_date.nil? ? s_date.end_of_day :
        Time.zone.parse(end_date).end_of_day

      ids = VehicleRoute.where(vehicle_id: vehicle_id).map { |record| record.id }.uniq
      VehicleRouteSchedule
        .where(vehicle_route_id: ids)
        .where('etd BETWEEN ? AND ?', s_date, e_date)
    end
  end
end
