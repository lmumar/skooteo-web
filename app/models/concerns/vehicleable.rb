# frozen_string_literal: true

module Vehicleable
  extend ActiveSupport::Concern

  included do
    has_one :vehicle, as: :vehicleable, touch: true, dependent: :destroy
    accepts_nested_attributes_for :vehicle

    delegate :image, :name, :capacity, :credits_per_spot, :status, :connected_to_node_at, to: :vehicle, allow_nil: true
  end
end
