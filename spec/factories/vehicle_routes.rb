# frozen_string_literal: true

FactoryBot.define do
  factory :vehicle_route do
    route
    skip_event_tracking { true }
    estimated_travel_time { 1_800 }
    association :vehicle, :active_service
  end
end
