# frozen_string_literal: true

FactoryBot.define do
  factory :addon do
    association :creator

    trait :advertising_addon do
      code { 'advertising' }
      description { 'Allow advertisers to buy spots from your fleet' }
    end

    trait :media_addon do
      code { 'media' }
      description { 'Allow media addon' }
    end
  end
end
