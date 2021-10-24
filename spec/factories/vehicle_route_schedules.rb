# frozen_string_literal: true

FactoryBot.define do
  factory :vehicle_route_schedule do
    factory :nautilus_cebu_camotes_route_sched1 do
      route
      etd  { Time.current }
      eta  { 2.hours.since(Time.current) }
      association :vehicle_route

      trait :active do
        status { VehicleRouteSchedule.statuses[:active] }
      end
    end
  end
end
