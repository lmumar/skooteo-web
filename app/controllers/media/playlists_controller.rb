# frozen_string_literal: true

module Media
  class PlaylistsController < BaseController
    include Playlists::Admin

    def archive
      set_playlist
      @playlist.archived!
    end

    protected
      def namespace
        @ns ||= 'media'
      end

      def playlist_type
        nil
      end
  end
end
