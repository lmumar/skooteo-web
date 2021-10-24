# frozen_string_literal: true

FactoryBot.define do
  factory :vehicle do
    name { generate(:vessel_name) }
    capacity { 300 }
    fcm_notification_token { 'fooobaaaarrr' }
    association :vehicleable, factory: :vessel

    trait :active_service do
      status { Vehicle.statuses[:active_service] }
    end
  end
end
