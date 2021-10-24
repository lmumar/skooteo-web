# frozen_string_literal: true

class Vessel::NotifyDownloadVideosJob < ApplicationJob
  # Notifies subscribed vessels of new videos it needs to download.
  #
  # <tt>vehicle</tt>
  def perform(vehicle)
    return unless vehicle.vessel? && vehicle.fcm_notification_token.present?

    now = Time.current
    start_time = now.beginning_of_year
    end_time = now.end_of_year
    video_ids = vehicle.company.videos.
      where('created_at BETWEEN ? AND ?', start_time, end_time).pluck(:id)

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
