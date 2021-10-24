# frozen_string_literal: true

FactoryBot.define do
  factory :trip_log do
    status { TripLog.statuses[:ready] }
    trip_etd { 1.day.since }
    trip_eta { 2.hours.since(1.day.since) }
  end
end
