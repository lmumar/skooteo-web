# frozen_string_literal: true

FactoryBot.define do
  factory :media_setting do
    vehicle_route
    regular_ads_length { 120 }
    regular_ads_segment_length { 15 }
    premium_ads_length { 120 }
    premium_ads_segment_length { 15 }
  end
end
