# frozen_string_literal: true

module Mutations
  module Vessels
    class DisconnectFromNode < ::Mutations::BaseMutation
      argument :vessel_id, ID, required: true

      type Boolean

      def resolve(vessel_id:)
        v = Vessel.find_by_id(vessel_id)
        return false if v.nil? || v.connected_to_node_at.blank?
        v.vehicle.connected_to_node_at = nil
        v.vehicle.save
      end
    end
  end
end
