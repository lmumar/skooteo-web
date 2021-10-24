# frozen_string_literal: true

module Queries
  class EntertainmentVideos < BaseQuery
    description "Find all entertainment videos for a vessel"

    argument :id, ID, required: true
    argument :channel, Types::ChannelTypes, required: true

    type [ID], null: false

    def resolve(id:, channel:)
      vehicle = Vehicle.find id
      company = vehicle.company
      playlists = company.playlists.where(channel: channel)
      playlists.flat_map { |playlist|
        playlist.playlist_videos.
          order(:play_order).pluck(:video_id)
      }
    end
  end
end
