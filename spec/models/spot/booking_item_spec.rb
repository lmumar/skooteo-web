# frozen_string_literal: true

require 'rails_helper'

describe Spot::BookingItem do
  include_context 'creator'

  let(:fleet_company) do
    company = nil
    Current.set(user: creator) {
      company = create(:royale_fleet)
    }
    company
  end

  let(:operator) { create(:nemo, company: fleet_company) }

  describe '.bulk_clone' do
    let(:etd) { Time.current }
    let(:eta) { 2.hours.since(etd) }

    let(:reference_schedule) do
      Current.set(user: operator) do
        ms = create(:media_setting)
        create(
          :nautilus_cebu_camotes_route_sched1,
          :active,
          etd: etd,
          eta: eta,
          route: ms.vehicle_route.route,
          vehicle_route: ms.vehicle_route
        )
      end
    end

    let(:reference_booking_item) do
      reference_booking_item = described_class.from(vehicle_route_schedule: reference_schedule)
      reference_booking_item.booked_regular_spots = 1
      reference_booking_item.booked_premium_spots = 1
      reference_booking_item
    end

    before do
      setd = etd
      seta = eta
      (0...7).each do
        setd = 1.day.since(setd)
        seta = 1.day.since(seta)
        Current.set(user: operator) do
          create(
            :nautilus_cebu_camotes_route_sched1,
            :active,
            etd: setd,
            eta: seta,
            route: reference_schedule.route,
            vehicle_route: reference_schedule.vehicle_route
          )
        end
      end
    end

    context 'No schedules to clone' do
      it 'returns an empty list' do
        route_schedules = VehicleRouteSchedule.order(:etd).to_a
        first_schedule  = route_schedules.shift
        VehicleRouteSchedule.where.not(id: first_schedule.id).delete_all
        clones = described_class.bulk_clone([reference_booking_item], 2, 1)
        expect(clones.empty?).to be(true)
      end
    end

    context 'clone with 1 day interval' do
      it 'creates booking item clones' do
        clones = described_class.bulk_clone([reference_booking_item], 2, 1)
        expect(clones.size).to eq(2)

        current_etd = Date.today
        clones.sort_by(&:etd).each do |booking_item|
          booked_etd = booking_item.etd.to_date
          expect(booked_etd > current_etd).to be(true)
          current_etd = booked_etd
        end
      end
    end

    context 'clone with interval > 1 day' do
      it 'creates booking item clones' do
        starting_date = Date.current
        expected_dates = [
          2.days.since(starting_date),
          4.days.since(starting_date),
          6.days.since(starting_date),
        ]

        clones = described_class.bulk_clone([reference_booking_item], 4, 2)
        cloned_dates = clones.map { |booking_item| booking_item.etd.to_date }.sort
        expect(expected_dates).to eq(cloned_dates)
      end
    end
  end
end
