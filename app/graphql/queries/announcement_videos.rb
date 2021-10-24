# frozen_string_literal: true

module Queries
  class AnnouncementVideos < BaseQuery
    description "Find all announcement videos for a vessel"

    argument :id, ID, required: true
    argument :type, Types::AnnouncementPlaylistTypes, required: true

    type [ID], null: false

    def resolve(id:, type:)
      vehicle = Vehicle.find(id)
      company = vehicle.company

      playlists = company.playlists.default.where(type: type)
      playlists.flat_map { |playlist|
        playlist.playlist_videos.
          order(:play_order).pluck(:video_id)
      }
    end
  end
end
