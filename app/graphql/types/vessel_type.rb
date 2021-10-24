# frozen_string_literal: true

module Types
  class VesselType < BaseObject
    field :id, ID, null: false
    field :kind, String, null: false
    field :name, String, null: false
    field :status, String, null: true
  end
end
