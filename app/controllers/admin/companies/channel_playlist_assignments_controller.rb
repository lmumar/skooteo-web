# frozen_string_literal: true

module Admin
  module Companies
    class ChannelPlaylistAssignmentsController < Admin::BaseController
      before_action :set_company
      before_action :set_playlist, only: %w(new create)
      before_action :set_videos, only: %w(create)

      def new
        @videos  = @company.videos.approved.playable.where(video_type: Skooteo::ENTERTAINMENT_VIDEO_TYPE)
        @videos += VideoSearch.results(filters: { company_type: Company.company_types['content_provider'] })
        respond_to do |format|
          format.js { render template: 'admin/companies/channel_playlist_assignments/edit.js.erb', layout: false }
        end
      end

      def create
        next_playorder = ((@playlist.playlist_videos.order(:play_order).last&.play_order) || -1) + 1
        @playlist.transaction do
          @videos.each_with_index { |video, i|
            @playlist.playlist_videos.add_video!(video, @company, next_playorder + i)
          }
        end
        respond_to do |format|
          format.js
        end
      end

      private

      def set_company
        @company = Company.find(params[:company_id])
      end

      def set_playlist
        @playlist = @company.playlists.find(params[:playlist_id])
      end

      def set_videos
        @videos = Video.where(id: video_params)
      end

      def video_params
        params.require(:video_ids)
      end
    end
  end
end
