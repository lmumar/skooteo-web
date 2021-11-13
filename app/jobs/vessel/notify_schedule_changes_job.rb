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

    payload = construct_payload_for_notification_type(notification_type, vehicle, trip_id)
    message = {
      data: payload,
      token: vehicle.fcm_notification_token
    }
    begin
      FirebaseCloudMessenger.send(message: message)
    rescue FirebaseCloudMessenger::Error => e
      Rails.logger.error { "(#{e.response_status}) #{e.short_message}" }
    end
  end

  private
    def construct_payload_for_notification_type(notification_type, vehicle, trip_id)
      payload = {
        notification_type: notification_type,
        trip_id: trip_id.to_s,
        vessel_id: vehicle.vessel.id.to_s
      }
      case notification_type
      when notification_types.new_schedule, notification_types.updated_schedule
        trip_config = Rails.application.config_for(:globals)
        trip = VehicleRouteSchedule.find(trip_id)
        trip_route = trip.vehicle_route
        media_setting = trip.vehicle_route.media_setting
        payload.merge(
          route_id: trip.route_id.to_s,
          route_name: trip.route.name,
          first_half_distance: trip.route.first_half_distance.km.to_s,
          distance: trip.route.distance.km.to_s,
          origin: trip.route.origin,
          destination: trip.route.destination,
          regular_ads_alloted_time_in_minutes: media_setting.regular_ads_duration.in_minutes.to_s,
          regular_ads_segment_length_in_minutes: media_setting.regular_ads_segment_duration.in_minutes.to_s,
          premium_ads_alloted_time_in_minutes: media_setting.premium_ads_duration.in_minutes.to_s,
          premium_ads_segment_length_in_minutes: media_setting.premium_ads_segment_duration.in_minutes.to_s,
          estimated_trip_duration_in_minutes: trip_route.estimated_travel_duration.in_minutes.to_s,
          eta_sampler_trigger_in_minutes: trip_config.fetch(:eta_sampler_trigger_in_minutes).to_s,
          on_boarding_time_in_minutes: media_setting.onboarding_duration.in_minutes.to_s,
          off_boarding_time_in_minutes: media_setting.offboarding_duration.in_minutes.to_s,
          arrival_trigger_in_minutes: media_setting.arrival_trigger_duration.in_minutes.to_s,
          trip_end_buffer_in_minutes: trip_config.fetch(:trip_end_buffer_in_minutes).to_s,
          trip_status_text: trip.status_text,
          trip_status: trip.status_before_type_cast.to_s,
          etd: trip.etd.utc.to_s,
          eta: trip.eta.utc.to_s
        )
      when notification_types.deleted_schedule, notification_types.cancelled_schedule
        payload
      end
    end
end
