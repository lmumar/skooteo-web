# frozen_string_literal: true

module HasCreator
  extend ActiveSupport::Concern

  included do
    belongs_to :creator, class_name: 'User', foreign_key: 'creator_id', default: -> { Current.user }
  end
end
