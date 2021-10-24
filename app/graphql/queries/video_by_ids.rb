# frozen_string_literal: true

module Queries
  class VideoByIds < BaseQuery
    description "Find video by IDs"

    argument :ids, [ID], required: true

    type [Types::VideoType], null: true

    def resolve(ids:)
      ::Video.with_attached_content.where(id: ids)
    end
  end
end
