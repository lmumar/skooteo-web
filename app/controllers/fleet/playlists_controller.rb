# frozen_string_literal: true

module Fleet
  class PlaylistsController < BaseController
    include Playlists::Admin

    protected
      def namespace
        @ns ||= 'fleet'
      end
  end
end
