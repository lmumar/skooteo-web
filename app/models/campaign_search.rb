# frozen_string_literal: true

class CampaignSearch
  include SearchObject.module

  scope {
    Campaign.includes(spots: [:vehicle_route_schedule, :time_slot, :route])
  }

  option(:company) { |scope, company| scope.where company_id: company.id }
  option(:start_date) { |scope, start_date| scope.where 'start_date >= ?', start_date }
  option(:end_date) { |scope, end_date| scope.where 'end_date < ?', end_date }
end
