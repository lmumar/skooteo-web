# frozen_string_literal: true

module ContentProvider
  class VideosController < BaseController
    before_action :set_videos, only: %w(index)
    before_action :set_video, only: %w(edit update destroy)

    def new
      @video = Current.user.videos.build
      respond_to do |format|
        format.js { render_edit_form }
      end
    end

    def create
      @video = Current.user.videos.build video_params
      @video.company = Current.company
      @video.pending!
    end

    def update
      @video.update_attributes! video_params
      respond_to do |format|
        format.js
      end
    end

    def destroy
      authorize @video
      @video.destroy
      respond_to do |format|
        format.html { head :ok }
        format.js
      end
    end

    private

    def set_videos
      @videos = VideoSearch.results(
        filters: {
          company: Current.company,
          sort: 'updated_at desc'
        },
        page: params[:page] || 1,
        per_page: 100
      )
    end

    def set_video
      @video = Video.find params[:id]
    end

    def video_params
      params.require(:video).permit(:name, :expire_at, :content)
    end

    def render_edit_form
      render template: 'content_provider/videos/edit.js.erb', layout: false
    end
  end
end
