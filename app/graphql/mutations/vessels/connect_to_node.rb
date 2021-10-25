# frozen_string_literal: true

module Mutations
  module Vessels
    class ConnectToNode < ::Mutations::BaseMutation
      argument :vessel_id, ID, required: true
      argument :fcm_notification_token, String, required: true

      type Boolean

      def resolve(vessel_id:, fcm_notification_token:)
        v = Vessel.find_by_id(vessel_id)
        return false if v.nil? || v.connected_to_node_at.present?

        v.vehicle.connected_to_node_at = Time.current
        v.vehicle.fcm_notification_token = fcm_notification_token
        v.vehicle.save!

        # Wait for approximately 2 seconds to give time for the device
        # to save the device token, otherwise the device might miss the
        # initial video download notification
        Vessel::NotifyDownloadVideosJob
          .set(wait: 2.seconds)
          .perform_later(v.vehicle)

        true
      end
    end
  end
end
