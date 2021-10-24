module Fleet
  class ChannelsController < BaseController
    before_action :set_channels

    private

    def set_channels
      @channels = Channels.new Current.company
    end
  end
end
