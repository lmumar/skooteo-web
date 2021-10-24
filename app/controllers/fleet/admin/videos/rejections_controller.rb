# frozen_string_literal: true

class Fleet::Admin::Videos::RejectionsController < ApplicationController
  before_action :set_video

  def create
    @video.rejected!
    @video.broadcast_replace_to Current.user, 'fleet:admin:videos', partial: 'fleet/admin/videos/video'
    respond_to do |format|
      format.any { head :ok }
    end
  end

  private
    def set_video
      @video = Video.find(params[:video_id])
    end
end
