# frozen_string_literal: true

class AppSchema < GraphQL::Schema
  use(GraphQL::Batch)

  mutation(Types::MutationType)
  query(Types::QueryType)
end
