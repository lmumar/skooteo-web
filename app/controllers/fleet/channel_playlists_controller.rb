# frozen_string_literal: true

module Fleet
  class ChannelPlaylistsController < BaseController
    before_action :set_playlists, only: %w(index)

    private
      def set_playlists
        @playlists = Current.company.playlists.active.
          where(channel: params[:channel]).order(:created_at)
        @channel = params[:channel]
      end
  end
end
