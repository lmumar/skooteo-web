# frozen_string_literal: true

class Fleet::Admin::VideosController < Fleet::BaseController
  before_action :set_videos, only: %w(index)

  def index
    respond_to do |format|
      format.html
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("list_videos", partial: 'videos')
      }
    end
  end

  private
    def set_videos
      @videos = Video.search(
        filters: {
          video_type: video_type,
          demo_or_skooteo: Current.company.demo?,
          sort: 'created_at desc'
        },
        page: params[:page] || 1,
        per_page: params[:per_page],
      )
    end

    def video_type
      params[:video_type] || Video.types.entertainment
    end
end
