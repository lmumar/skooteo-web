# frozen_string_literal: true

module Fleet
  class PlaylistVideosController < BaseController
    skip_before_action :require_fleet_operator!, only: %w(destroy)
    before_action :set_playlist, except: %w(destroy)
    before_action :set_playlist_video, only: %w(set_play_order destroy)

    def destroy
      @playlist_video.destroy
      @playlist_video.broadcast_remove_to 'fleet:playlist'
      respond_to do |format|
        format.any { head :ok }
      end
    end

    def set_play_order
      @playlist.switch_playorder!(@playlist_video, params[:play_order].to_i)
      head :ok
    end

    private
      def set_playlist
        @playlist = Current.company.playlists.find params[:playlist_id]
      end

      def set_playlist_video
        @playlist_video = PlaylistVideo.find params[:id]
      end
  end
end
