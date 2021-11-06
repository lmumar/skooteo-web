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

    videos = vehicle
      .company
      .videos
      .with_attached_content
      .where('created_at BETWEEN ? AND ?', start_time, end_time)

    video_attrs = videos.map do |video|
      video_url = content_url(video.content)
      video.attributes.slice('id', 'name')
        .merge('url' => video_url)
    end

    message = {
      data: {
        notification_type: 'new_videos',
        videos_json: JSON.dump(video_attrs),
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

  private
    def content_url(content)
      Rails.env.production? ? content.service_url :
        Rails.application.routes.url_helpers.rails_blob_url(content, only_path: false)
    end
end
