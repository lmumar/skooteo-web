module Media
  class PlaylistVideosController < BaseController
    before_action :set_playlist, except: %w(destroy)
    before_action :set_playlist_video, only: %w(set_play_order destroy)

    def destroy
      authorize @playlist_video
      @playlist_video.destroy
      head :ok
    end

    def set_play_order
      ordered = @playlist.playlist_videos.order(:play_order)
      @playlist.transaction do
        old_play_order = @playlist_video.play_order
        new_play_order = params[:play_order].to_i

        other_playlist_video = ordered[new_play_order]
        @playlist_video.play_order = new_play_order
        @playlist_video.save!

        other_playlist_video.play_order = old_play_order
        other_playlist_video.save!
      end
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
