# frozen_string_literal: true
class Event < ApplicationRecord
  belongs_to :recordable, polymorphic: true
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
end
