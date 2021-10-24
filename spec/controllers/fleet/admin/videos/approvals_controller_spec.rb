# frozen_string_literal: true

require 'rails_helper'

describe Fleet::Admin::Videos::ApprovalsController, type: :controller do
  include_context 'creator'
  include_context 'video'

  let(:session_user) { create(:nemo) }

  let(:video) do
    video_config = create_video_config(session_user, 6, Video.statuses[:pending])
    Current.set(user: session_user) { create_videos(video_config).first }
  end

  describe 'POST create' do
    before do
      cookies.encrypted[:user_id] = session_user.id
    end

    it 'response with a status code of 200' do
      expect(post(:create, params: { video_id: video.id })).to have_http_status(:ok)
    end

    it 'sends notifications' do
      Current.set(user: session_user) { create(:vehicle) }
      expect(Vessel::NotifyDownloadVideosJob).to receive(:perform_later).once
      post(:create, params: { video_id: video.id })
    end
  end
end
