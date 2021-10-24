# frozen_string_literal: true

module Admin
  class VideosController < BaseController
    before_action :set_videos, only: %w(index)
    before_action :set_video, only: %w(approve reject)

    def approve
      @video.screened!
      respond_to do |format|
        format.any { head :ok }
      end
    end

    def reject
      @video.rejected!
      respond_to do |format|
        format.any { head :ok }
      end
    end

    private
      def set_videos
        @videos = Video.search(
          filters: {
            non_demo: true,
            non_skooteo: true,
            sort: 'updated_at desc'
          },
          page: params[:page] || 1,
          per_page: params[:per_page],
        )
      end

      def set_video
        @video = Video.find params[:id]
      end
  end
end
