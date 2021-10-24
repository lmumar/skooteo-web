# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimeSlot, type: :model do
  describe '.update_available_spots' do
    include_context 'creator'

    let(:time_slot) do
      Current.set(user: creator) do
        schedule = create(:nautilus_cebu_camotes_route_sched1)
        create(:time_slot,
          vehicle_route_schedule: schedule,
          vehicle_route: schedule.vehicle_route,
          vehicle: schedule.vehicle,
          company: schedule.vehicle.company,
          route: schedule.route,
        )
      end
    end

    context 'non-concurrent' do
      it 'updates the available field' do
        time_slot.update_available_spots(
          Spot.types.regular,
          50
        )
        expect(time_slot.available_regular_spots).to eq(50)
      end
    end

    context 'concurrent updates' do
      it 'updates the avaiable field' do
        threads  = []
        bookings = Set.new
        (0..2).each do |index|
          threads << Thread.new do
            booked = time_slot.update_available_spots(
              Spot.types.regular,
              75
            )
            bookings.add(booked)
          end
        end
        threads.each(&:join)
        expect(time_slot.available_regular_spots).to eq(0)
        expect(bookings).to eq([75, 25, 0].to_set)
      end
    end
  end
end
