# frozen_string_literal: true

class Spot::TriggerVesselNotifyNewVideoJob < ApplicationJob
  def perform(spot)
    return if spot.playlist.nil?

    spot.playlist.videos.each { |video|
      notify_vessel(spot.vehicle_route_schedule.vehicle, spot.playlist.video_ids)
    }
  end

  private
    def notify_vessel(vehicle, video_ids)
      message = {
        data: {
          notification_type: 'new_videos',
          video_ids: video_ids.join(','),
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
