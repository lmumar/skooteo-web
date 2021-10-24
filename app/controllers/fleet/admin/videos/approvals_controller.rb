# frozen_string_literal: true

class Fleet::Admin::Videos::ApprovalsController < ApplicationController
  before_action :set_video

  def create
    @video.approved!
    @video.broadcast_replace_to Current.user, 'fleet:admin:videos', partial: 'fleet/admin/videos/video'

    Current.company.vehicles.each { |vehicle|
      Vessel::NotifyDownloadVideosJob.perform_later(vehicle)
    }

    respond_to do |format|
      format.any { head :ok }
    end
  end

  private
    def set_video
      @video = Video.find(params[:video_id])
    end
end
