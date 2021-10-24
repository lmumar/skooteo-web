# frozen_string_literal: true

class Vessel::NotifyScheduleChangesJob < ApplicationJob
  include Const

  const notification_types: %w[new_schedule updated_schedule deleted_schedule cancelled_schedule]

  # Notifies subscribed vessels of vessel schedule changes.
  #
  # <tt>vehicle</tt>
  # <tt>trip_id</tt> - the id of the updated trip (VehicleRouteSchedule)
  # <tt>notification_type</tt> - check Vessel::NotifyScheduleChangesJob.notification_types
  def perform(vehicle, trip_id, notification_type)
    return unless vehicle.vessel? && vehicle.fcm_notification_token.present? && trip_id.present?
    Rails.logger.info { "Notifying vehicle #{vehicle.id} of updated trip #{trip_id}" }
    message = {
      data: {
        notification_type: notification_type,
        trip_id: trip_id&.to_s,
        vessel_id: vehicle.vessel.id.to_s
      },
      token: vehicle.fcm_notification_token
    }
    begin
      FirebaseCloudMessenger.send(message: message)
    rescue FirebaseCloudMessenger::Error => e
      Rails.logger.error { "(#{e.response_status}) #{e.short_message}" }
    end
  end
end
