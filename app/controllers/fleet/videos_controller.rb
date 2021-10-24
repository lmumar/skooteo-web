# frozen_string_literal: true

module Fleet
  class VideosController < BaseController
    before_action :set_videos, only: %w(index)
    before_action :set_video, only: %w(edit update destroy)

    def edit
      render_edit
    end

    def new
      @video = Current.user.videos.build
      @video.video_type = params[:video_type] if params[:video_type].present?
      render_edit
    end

    def create
      @video = Current.company.videos.build video_params
      policy(@video).auto_approve? ? @video.approved! : @video.pending!
    end

    def update
      authorize @video
      @video.update video_params
    end

    def destroy
      authorize @video
      @video.destroy
    end

    private
      def set_videos
        filters = { company: Current.company, sort: 'updated_at desc', video_type: params[:video_type] }
        @videos = VideoSearch.new(
          filters: filters,
          page: params[:page] || 1,
          per_page: params[:per_page]
        )
      end

      def set_video
        @video = Current.company.videos.find params[:id]
      end

      def video_params
        params.require(:video).permit(:name, :expire_at, :content, :video_type)
      end

      def render_edit
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.update("modal-container", partial: "edit") }
          format.html { redirect_to fleet_videos_path }
        end
      end
  end
end
