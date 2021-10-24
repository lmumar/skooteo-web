# frozen_string_literal: true

module VideoServices
  module_function

  def approve(video)
    company = video.company
    company.advertiser? ?
      approve_advertiser_video(company, video) :
      video.approved!
  end

  def reject(video)
    video.rejected!
  end

  def screen(video)
    video.screened!
  end

  def approve_advertiser_video(company, video)
    default_playlist = company.playlists.default.first
    video.transaction do
      video.approved!
      unless default_playlist
        default_playlist = company.playlists.create!(
          name: 'Default',
          creator: Current.user,
          status: 'default'
        )
      end
      if default_playlist.videos.empty?
        # remove expiry since only videos without expiry
        # can be added to the default playlist
        video.expire_at = nil
        video.save!
        default_playlist.playlist_videos.create!(
          video: video,
          play_order: 0
        )
      end
    end
  end
end
