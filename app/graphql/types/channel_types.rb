# frozen_string_literal: true

module Types
  class ChannelTypes < Types::BaseEnum
    value "GENERAL_VIDEO", "General", value: Video.channels.general
    value "MOVIES", "Movies", value: Video.channels.movies
    value "CONCERT", "Concert", value: Video.channels.concert
    value "MUSIC_VIDEO", "Music Videos", value: Video.channels.music_videos
  end
end
