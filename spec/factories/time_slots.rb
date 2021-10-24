# frozen_string_literal: true

FactoryBot.define do
  factory :time_slot do
    available_regular_spots { 100 }
    available_premium_spots { 100 }
  end
end
