# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Video, type: :model do
  include_context 'creator'
  include_context 'video'

  describe '.approve!' do
    context 'advertiser' do
      it 'marks the video as approved and add it to the empty default playlist' do
        Current.set(user: creator_advertiser) do
          video_config = create_video_config(Current.user, 6, Video.statuses[:pending])
          video = create_videos(video_config).first
          expect {
            video.approve!
          }.to change { video.status }
            .and change { PlaylistVideo.count }.by(1)
        end
      end
    end

    context 'fleet operator' do
      it 'marks the video as approved' do
        Current.set(user: creator_fleet_operator) do
          video_config = create_video_config(Current.user, 6, Video.statuses[:pending])
          video = create_videos(video_config).first
          expect {
            video.approve!
          }.to change { video.status }
            .and change { PlaylistVideo.count }.by(0)
        end
      end
    end
  end
end
