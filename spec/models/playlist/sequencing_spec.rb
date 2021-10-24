# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlist::Sequencing do
  subject { described_class }

  include_context 'creator'
  include_context 'sequencing utils'

  let(:user1) { create(:acmejohn) }
  let(:user2) { create(:acmejohn) }

  describe '.call' do
    context 'when timeslot is nil' do
      it 'returns nil' do
        expect(subject.new(nil).call).to be(nil)
      end
    end

    context 'when ad allotted time = segment allotted time' do
      it 'creates a single segment node playlist' do
        Current.set(user: creator_advertiser) do
          campaigns = create_campaigns([user1, user2])
          playlists = create_playlists([user1, user2])

          spot_configs = (0...campaigns.size).map { |i|
            create_spot_config(
              timeslot,
              campaigns[i],
              vehicle_route_schedule,
              1,
              playlists[i]
            )
          }

          create_spots(spot_configs)
          video_configs = (0...campaigns.size).map { |i|
            create_video_config(playlists[i].creator)
          }

          videos = create_videos(video_configs)
          (0...playlists.size).each { |i|
            create_playlist_video(playlists[i], [videos[i]], playlists[i].creator.company)
          }

          sequencer = subject.new(timeslot)
          result = sequencer.call
          expect(result.dig(:premium, :sequence).length).to be(0)
          expect(result.dig(:regular, :sequence).length).to be(1)
        end
      end
    end

    context 'when ad allotted time > segment allotted time (multi-segment)' do
      it 'creates a multi segment node playlist' do
        Current.set(user: creator_advertiser) do
          campaigns = create_campaigns([user1, user2])
          playlists = create_playlists([user1, user2])

          vehicle_route_schedule.eta = 2.minutes.since(vehicle_route_schedule.etd)
          vehicle_route_schedule.save!

          vehicle_route.estimated_travel_duration = 4.minutes
          vehicle_route.save!

          media_setting = vehicle_route.media_setting
          media_setting.regular_ads_duration = 2.minutes
          media_setting.premium_ads_duration = 2.minutes
          media_setting.save!

          spot_configs = [
            create_spot_config(
              timeslot,
              campaigns[0],
              vehicle_route_schedule,
              1,
              playlists[0]
            ),
            create_spot_config(
              timeslot,
              campaigns[0],
              vehicle_route_schedule,
              1,
              playlists[0],
              Spot.types.premium,
              1.25
            ),
            create_spot_config(
              timeslot,
              campaigns[1],
              vehicle_route_schedule,
              1,
              playlists[1]
            )
          ]
          create_spots(spot_configs)
          video_configs = (0...campaigns.size).map { |i|
            create_video_config(playlists[i].creator)
          }
          videos = create_videos(video_configs)
          (0...playlists.size).each { |i|
            create_playlist_video(playlists[i], [videos[i]], playlists[i].creator.company)
          }
          sequencer = subject.new(timeslot)
          result = sequencer.call

          expect(result[:video_ids].length).to be(2)
          expect(result.dig(:regular, :sequence).length).to be(2)
          expect(result.dig(:premium, :sequence).length).to be(1)
        end
      end
    end

    context 'when playlist video duration <= 15s' do
      it 'sequence videos where total sequenced video = total booked spots' do
        Current.set(user: creator_advertiser) do
          campaigns = create_campaigns([user1])
          playlists = create_playlists([user1])
          spot_configs = (0...campaigns.size).map { |i|
            create_spot_config(
              timeslot,
              campaigns[i],
              vehicle_route_schedule,
              2,
              playlists[i]
            )
          }
          create_spots(spot_configs)
          video_configs = [
            create_video_config(playlists[0].creator, 10),
            create_video_config(playlists[0].creator, 15),
          ]

          videos = create_videos(video_configs)
          (0...2).each { |i|
            create_playlist_video(playlists[0], [videos[i]], playlists[0].creator.company)
          }
          sequencer = subject.new(timeslot)
          playlist = sequencer.call
          expect(playlist[:video_ids].length).to be(2)
          expect(playlist.dig(:regular, :sequence).length).to be(1)
          expect(playlist.dig(:regular, :sequence)[0].length).to be(Spot.sum(:count))
        end
      end
    end

    context 'when playlist video duration > 15s' do
      it 'sequence videos based on the total spots available' do
        Current.set(user: creator_advertiser) do
          campaigns = create_campaigns([user1])
          playlists = create_playlists([user1])
          spot_configs = (0...campaigns.size).map { |i|
            create_spot_config(
              timeslot,
              campaigns[i],
              vehicle_route_schedule,
              2,
              playlists[i]
            )
          }
          create_spots(spot_configs)
          video_configs = [create_video_config(playlists[0].creator, 17)]

          videos = create_videos(video_configs)
          (0...playlists.size).each { |i|
            create_playlist_video(playlists[i], [videos[i]], playlists[i].creator.company)
          }

          sequencer = subject.new(timeslot)
          playlist = sequencer.call
          expect(playlist[:video_ids].length).to be(Video.count)
          expect(playlist.dig(:regular, :sequence).length).to be(1)
          expect(playlist.dig(:regular, :sequence)[0].length).to be(Spot.sum(:count))
        end
      end
    end

    context 'when booked spot cannot cover the playlist video duration' do
      it 'does not create any play sequence videos' do
        Current.set(user: creator_advertiser) do
          campaigns = create_campaigns([user1])
          playlists = create_playlists([user1])
          spot_configs = (0...campaigns.size).map { |i|
            create_spot_config(
              timeslot,
              campaigns[i],
              vehicle_route_schedule,
              2,
              playlists[i]
            )
          }
          create_spots(spot_configs)
          video_configs = [create_video_config(playlists[0].creator, 35)]

          videos = create_videos(video_configs)
          (0...playlists.size).each { |i|
            create_playlist_video(playlists[i], [videos[i]], playlists[i].creator.company)
          }
          allow_any_instance_of(Video).to receive(:consumable_spot_count).and_return(3)
          sequencer = subject.new(timeslot)
          playlist = sequencer.call
          expect(playlist[:video_ids].length).to be(0)
          expect(playlist.dig(:regular, :sequence).length).to be(0)
        end
      end
    end

    context 'when playlist videos < total booked spots' do
      it 'repeats the videos to accommodate remaining spots' do
        Current.set(user: creator_advertiser) do
          campaigns = create_campaigns([user1])
          playlists = create_playlists([user1])
          spot_configs = (0...campaigns.size).map { |i|
            create_spot_config(
              timeslot,
              campaigns[i],
              vehicle_route_schedule,
              2,
              playlists[i]
            )
          }
          create_spots(spot_configs)
          video_configs = [create_video_config(playlists[0].creator, 15)]

          videos = create_videos(video_configs)
          (0...playlists.size).each { |i|
            create_playlist_video(playlists[i], [videos[i]], playlists[i].creator.company)
          }
          sequencer = subject.new(timeslot)
          playlist = sequencer.call
          expect(playlist[:video_ids].length).to be(1)
          expect(playlist.dig(:regular, :sequence).length).to be(1)
          expect(playlist.dig(:regular, :sequence)[0].length).to be(Spot.sum(:count))
          expect(playlist.dig(:regular, :sequence)[0].uniq.length).to be(1)
        end
      end
    end
  end
end
