# frozen_string_literal: true

FactoryBot.define do
  factory :company, class: 'Company' do
    name { generate(:company_name) }
    time_zone { 'Asia/Manila' }

    trait :fleet_operator do
      company_type { :fleet_operator }
      after(:create) do |company, evaluator|
        %i[advertising_addon media_addon].each do |trt|
          attrs = attributes_for(:addon, trt)
          addon = Addon.find_or_initialize_by(attrs)
          addon.creator = company.system_account
          addon.save!
          company.company_addons.find_or_create_by(addon: addon, creator: company.system_account)
        end
      end
    end

    trait :advertiser do
      company_type { :advertiser }
    end

    trait :content_provider do
      company_type { :content_provider }
    end

    factory :acme_ads,     traits: [ :advertiser ]
    factory :acme_movies,  traits: [ :content_provider ]
    factory :royale_fleet, traits: [ :fleet_operator ]
    factory :skooteo,      traits: [ :skooteo ]
  end
end
