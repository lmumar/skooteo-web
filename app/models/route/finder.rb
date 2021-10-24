# frozen_string_literal: true

class Route::Finder
  include SearchObject.module :will_paginate, :sorting

  scope { Route.order('routes.name') }
  per_page 30

  option(:company_ids) { |scope, company_ids|
    scope.where company_id: company_ids
  }

  option(:query) { |scope, query|
    (query && scope.where(['search_keywords ILIKE ?', "%#{query}%"])) || scope
  }
end
