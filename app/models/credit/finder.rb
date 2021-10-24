# frozen_string_literal: true

class Credit::Finder
  include SearchObject.module :will_paginate, :sorting

  scope { Credit.with_running_balance }

  option(:company) { |scope, company| scope.where(company_id: company.id) }

  per_page 30
end
