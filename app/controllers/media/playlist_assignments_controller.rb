# frozen_string_literal: true

module Media
  class PlaylistAssignmentsController < BaseController
    before_action :set_playlist, only: %w(new create)
    before_action :set_videos, only: %w(create)

    def new
      @videos = Video.selections(Current.company, @playlist)
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.update('modal-container', partial: 'edit')
        }
        format.html {
          redirect_to media_playlists_path
        }
      end
    end

    def create
      @playlist.transaction do
        @videos.each { |video|
          @playlist.playlist_videos.find_or_create_by!(video: video, company: Current.company)
        }
      end
      @playlist.broadcast_replace_to Current.user, 'media:playlist_assignment', partial: 'media/playlists/playlist', object: @playlist
      @playlist.broadcast_replace_to Current.user, 'media:playlist_assignment', partial: 'shared/modal', target: 'modal-container'
      respond_to do |format|
        format.any { head :ok }
      end
    end

    private
      def set_playlist
        @playlist = Current.company.playlists.find params[:playlist_id]
      end

      def set_videos
        @videos = Current.company.videos.where(id: video_params)
      end

      def video_params
        params.require(:video_ids)
      end
  end
end
