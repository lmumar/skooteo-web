# frozen_string_literal: true

class Company::Finder
  include SearchObject.module(:will_paginate, :sorting)
  scope { Company.fleet_operator.non_demo }

  option(:with_addons) { |scope, addons|
    scope
      .includes(company_addons: :addon)
      .where(addons: { code: addons })
  }

  option(:type) { |scope, value|
    value.present? ?
      scope.where(company_type: value).or(scope.where(company_type: Company.company_types['skooteo'])) :
      scope
  }

  option(:query) do |scope, query|
    where_string = "companies.name ILIKE '%<query>s'".% [query: "%#{query}%"]
    (query && scope.where(where_string) || scope)
  end

  per_page 30
  sort_by :name
end
