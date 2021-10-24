# frozen_string_literal: true

FactoryBot.define do
  factory :company_addon do
    association :company

    trait :with_advertising_addon do
      association :addon, :advertising_addon
    end

    trait :with_media_addon do
      association :addon, :media_addon
    end
  end
end
