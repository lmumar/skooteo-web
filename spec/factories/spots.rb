# frozen_string_literal: true

FactoryBot.define do
  factory :spot do
    cost_per_cpm { 1.00 }
    count { 100 }
    type { Spot.types.regular }
  end
end
