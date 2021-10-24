# frozen_string_literal: true

class MediaSetting < ApplicationRecord
  include Eventable
  include WithDurationFields

  using Skooteo::Patch::Number

  belongs_to :vehicle_route

  to_duration_field \
    regular_ads_length: :regular_ads_duration,
    premium_ads_length: :premium_ads_duration,
    regular_ads_segment_length: :regular_ads_segment_duration,
    premium_ads_segment_length: :premium_ads_segment_duration,
    onboarding_length: :onboarding_duration,
    offboarding_length: :offboarding_duration,
    arrival_trigger_time: :arrival_trigger_duration

  validates_uniqueness_of :vehicle_route_id

  def regular_spots
    (regular_ads_duration.in_seconds / Spot.video_durations.in_seconds).skstd_round
  end

  def premium_spots
    (premium_ads_duration.in_seconds / Spot.video_durations.in_seconds).skstd_round
  end
end
