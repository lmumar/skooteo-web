# frozen_string_literal: true

module Queries
  class Video < BaseQuery
    description "Find video by ID"

    argument :id, ID, required: true

    type Types::VideoType, null: true

    def resolve(id:)
      ::Video.with_attached_content.find_by_id(id)
    end
  end
end
