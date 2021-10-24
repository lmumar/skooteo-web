# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [ :creator ] do
    email { generate(:email) }
    password { "123456789" }

    trait :no_login do
      no_login { true }
    end

    factory :acmejohn do
      association :company, :advertiser, skip_event_tracking: true
    end

    factory :nemo do
      association :company, :fleet_operator, skip_event_tracking: true
    end

    factory :sysusr do
      no_login
      association :company, :skooteo, skip_event_tracking: true
    end
  end
end
