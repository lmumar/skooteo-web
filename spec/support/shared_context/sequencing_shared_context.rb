# frozen_string_literal: true

require 'ostruct'

RSpec.shared_context 'sequencing utils' do
  let(:vehicle_route_schedule) do
    vrsked = create(:nautilus_cebu_camotes_route_sched1)
    vrsked.etd = Time.current
    vrsked.eta = 1.minute.since(vrsked.etd)
    vrsked.save!
    vrsked
  end

  let(:vehicle_route) do
    vhr = vehicle_route_schedule.vehicle_route
    vhr.estimated_travel_duration = 1.minute
    vhr.save!

    media_setting = vhr.build_media_setting
    # media_setting.vehicle_route = vhr
    media_setting.premium_ads_duration = 1.minute
    media_setting.premium_ads_segment_duration = 1.minute
    media_setting.regular_ads_duration = 1.minute
    media_setting.regular_ads_segment_duration = 1.minute
    media_setting.save!

    vhr
  end

  let(:timeslot) do
    create(
      :time_slot,
      vehicle_route_schedule: vehicle_route_schedule,
      vehicle: vehicle_route_schedule.vehicle,
      company: Current.user.company,
      route: vehicle_route.route,
      available_regular_spots: 150,
      available_premium_spots: 150,
    )
  end

  let(:john_doe) do
    john_doe_account = create :john_doe_account, person: nil, company: nil
    create :john_doe_person_info, user: john_doe_account
    john_doe_account
  end

  let(:jack_doe) do
    jack_doe_account = create :jack_doe_account, person: nil
    create :jack_doe_person_info, user: jack_doe_account
    jack_doe_account
  end

  def create_campaigns(advertisers, start_date = Date.today, end_date = 3.days.since)
    advertisers.map.with_index { |advertiser, i|
      create(
        :campaign,
        name: "campaign-#{i}",
        advertiser: advertiser,
        company: advertiser.company,
        start_date: start_date,
        end_date: end_date
      )
    }
  end

  def create_playlists(creators, status = 0)
    creators.map.with_index { |creator, i|
      create(
        :playlist,
        name: "playlist-#{i}",
        status: status,
        company: creator.company,
        creator: creator
      )
    }
  end

  def create_playlist_video(playlist, videos, company)
    videos.map { |video|
      create(
        :playlist_video,
        company: company,
        playlist: playlist,
        video: video
      )
    }
  end

  def create_spot_config(
        timeslot,
        campaign,
        vehicle_route_schedule,
        booking_count,
        playlist,
        type = Spot.types.regular,
        cost = 1.0
      )
    config = OpenStruct.new
    config.timeslot = timeslot
    config.campaign = campaign
    config.vehicle_route_schedule = vehicle_route_schedule
    config.booking_count = booking_count
    config.playlist = playlist
    config.type = type
    config.cost = cost
    config
  end

  def create_spots(spot_configs)
    spot_configs.map do |config|
      create(
        :spot,
        time_slot: config.timeslot,
        campaign: config.campaign,
        vehicle_route_schedule: config.vehicle_route_schedule,
        route: config.vehicle_route_schedule.vehicle_route.route,
        count: config.booking_count,
        playlist: config.playlist,
        type: config.type,
        cost_per_cpm: config.cost,
        creator: config.playlist.creator,
      )
    end
  end

  def create_video_config(creator, duration = 6, status = 1)
    config = OpenStruct.new
    config.creator  = creator
    config.duration = duration
    config.status   = status
    config
  end

  def create_videos(video_configs)
    video_configs.map.with_index do |config, i|
      video = create(
        :video,
        name: "video-#{i}",
        status: config.status,
        company: config.creator.company,
        creator: config.creator
      )
      attachment = create_file_blob(
        filename: "sample.mp4",
        content_type: "video/mp4",
        metadata: { 'duration' => config.duration }
      )
      video.content.attach(attachment)
      video
    end
  end
end
