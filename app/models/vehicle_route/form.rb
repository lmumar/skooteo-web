# frozen_string_literal: true

class VehicleRoute::Form
  include ActiveModel::Model

  using Skooteo::Patch::ExtendedHash

  [%i[estimated_travel_duration ett],
  %i[onboarding_duration onboarding],
  %i[offboarding_duration offboarding],
  %i[arrival_trigger_duration arrival_trigger],
  %i[regular_ads_duration regular_ads],
  %i[premium_ads_duration premium_ads],
  %i[regular_ads_segment_duration regular_ads_segment],
  %i[premium_ads_segment_duration premium_ads_segment]].each do |pair|
    duration_method, accessor = pair
    attr_accessor accessor
    define_method duration_method do
      (send(accessor) || {}).to_duration
    end
  end

  def set(vehicle_route)
    vehicle_route.estimated_travel_duration = estimated_travel_duration || 0
    vehicle_route.media_setting.onboarding_duration = onboarding_duration || 0
    vehicle_route.media_setting.offboarding_duration = offboarding_duration || 0
    vehicle_route.media_setting.arrival_trigger_duration = arrival_trigger_duration || 0
    vehicle_route.media_setting.regular_ads_duration = regular_ads_duration || 0
    vehicle_route.media_setting.premium_ads_duration = premium_ads_duration || 0
    vehicle_route.media_setting.regular_ads_segment_duration = regular_ads_segment_duration || 0
    vehicle_route.media_setting.premium_ads_segment_duration = premium_ads_segment_duration || 0
  end
end
