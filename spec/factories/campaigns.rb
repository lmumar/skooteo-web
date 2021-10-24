# frozen_string_literal: true

FactoryBot.define do
  factory :campaign do
    name { 'Test campaign' }
    start_date { 2.days.since }
    end_date { 4.days.since }
  end
end
