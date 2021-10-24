# frozen_string_literal: true

module Admin
  module Companies
    class ChannelPlaylistsController < Admin::BaseController
      before_action :set_company, only: %w(index)
      before_action :set_playlists, only: %w(index)

      private

      def set_company
        @company = Company.find(params[:company_id])
      end

      def set_playlists
        @playlists = @company
          .playlists
          .active
          .where(channel: params[:channel])
          .order(:created_at)
        @channel = params[:channel]
      end
    end
  end
end
