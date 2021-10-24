# frozen_string_literal: true

module Admin
  module Companies
    class ChannelsController < Admin::BaseController
      before_action :set_company
      before_action :set_channels

      private

      def set_channels
        @channels = Channels.new(@company)
      end

      def set_company
        @company = Company.find(params[:company_id])
      end
    end
  end
end
