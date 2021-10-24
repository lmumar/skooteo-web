# frozen_string_literal: true

FactoryBot.define do
  factory :route do
    name { generate(:route_name) }
    distance { 10 }
    origin { 'Cebu City' }
    destination { 'Camotes Island' }
    association :creator
    association :company, factory: :royale_fleet
  end
end
