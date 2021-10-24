# frozen_string_literal: true

module Media
  class VideosController < BaseController
    before_action :set_videos, only: %w(index)
    before_action :set_video, only: %w(edit update destroy)

    def new
      @video = Current.user.videos.build
      render_edit
    end

    def edit
      render_edit
    end

    def create
      @video = Current.company.videos.build video_params
      @video.pending!
    end

    def update
      @video.update video_params
    end

    def destroy
      authorize @video
      @video.destroy
      @video.broadcast_remove_to Current.user, 'media:videos'
      respond_to do |format|
        format.any { head :ok }
      end
    end

    private
      def set_videos
        @videos = Video.search(
          filters: {
            status: params[:status],
            company: Current.company,
            sort: 'updated_at desc'
          },
          page: params[:page] || 1, per_page: params[:per_page]
        )
      end

      def set_video
        @video = Current.company.videos.find params[:id]
      end

      def video_params
        params.require(:video).permit(:name, :expire_at, :content)
      end

      def render_edit
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.update("modal-container", partial: "edit") }
          format.html { redirect_to media_videos_path }
        end
      end
  end
end
