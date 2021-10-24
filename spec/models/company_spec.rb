# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, type: :model do
  describe '.create' do
    include_context 'creator'

    context 'advertiser' do
      it 'creates default playlists' do
        Current.set(user: creator) do
          expect {
            Company.advertiser.create!(name: 'procter & gamble', time_zone: 'Asia/Manila')
          }.to change { Company.advertiser.count }.by(1)
            .and change { Playlist.default.count }.by(1)
            .and change { Playlist.count }.by(1)
        end
      end
    end

    context 'fleet operator' do
      it 'creates default channels' do
        Current.set(user: creator) do
          expect {
            Company.fleet_operator.create!(name: 'nerwhal shipping', time_zone: 'Asia/Manila')
          }.to change { Company.fleet_operator.count }.by(1)
            .and change { Playlist.count }.by(4)
        end
      end
    end
  end
end
