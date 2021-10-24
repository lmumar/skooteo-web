# frozen_string_literal: true
module Queries
  class BaseQuery < GraphQL::Schema::Resolver
    DEFAULT_LIMIT = 30
  end
end
