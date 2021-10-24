# frozen_string_literal: true
class UserSearch
  include SearchObject.module :will_paginate, :sorting
  per_page 30

  scope { User.joins(:person).order('people.last_name, people.first_name') }
  option(:query) do |scope, query|
    where_string = "people.first_name ILIKE '%<query>s' OR " \
                   "people.last_name ILIKE '%<query>s' OR " \
                   "users.email ILIKE '%<query>s'".% [query: "%#{query}%"]

    (query && scope.where(where_string)) || scope
  end
end
