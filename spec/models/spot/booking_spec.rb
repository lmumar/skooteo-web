# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spot::Booking, type: :model do
  include_context 'creator'

  let(:schedule) do
    Current.set(user: creator) {
      create :nautilus_cebu_camotes_route_sched1
    }
  end

  before do
    create(:time_slot,
      vehicle_route_schedule: schedule,
      vehicle_route: schedule.vehicle_route,
      vehicle: schedule.vehicle,
      company: schedule.vehicle.company,
      route: schedule.route,
    )
    creator_advertiser.company.credits.topup!(10000, creator_advertiser)
  end

  describe '.book' do
    let(:booking) {
      build_spot(
        campaign_name: 'foo',
        vehicle_route_schedule: schedule,
        premium_spots: 0,
        regular_spots: 50
      )
    }

    it 'create spots' do
      expect do
        Current.set(user: creator_advertiser) { booking.book }
      end.to change { Spot.regular.count }.by(1)
        .and change { creator_advertiser.company.spots.count }.by(1)
        .and change { Spot.regular.sum(:count) }.by(50)
    end

    it 'updates time slot spot availability' do
      expect do
        Current.set(user: creator_advertiser) { booking.book }
      end.to change { TimeSlot.where(vehicle_route_schedule: schedule).sum(:available_regular_spots) }.by(-50)
    end

    it 'updates company total credits' do
      expect do
        Current.set(user: creator_advertiser) { booking.book }
      end.to change { creator_advertiser.company.credits.sum(:amount) }.by(-booking.total_booking_cost)
    end

    it 'changes the state of the booking to confirmed' do
      Current.set(user: creator_advertiser) {
        booking.book
      }
      expect(booking.confirmed?).to be(true)
    end

    context 'when overbooking' do
      context 'non-parallel request' do
        it 'raises an exception' do
          creator_advertiser.company.credits.update_all(amount: 0)
          Current.set(user: creator_advertiser) do
            expect {
              booking.book
            }.to raise_error('Not enough credits')
          end
        end
      end

      context 'parallel request' do
        it 'allows first booking to succeed parallel bookings fail' do
          begin
            concurrency_level = 3
            bookings = concurrency_level.times.map {
              build_spot(
                campaign_name: 'foo',
                vehicle_route_schedule: schedule,
                premium_spots: 0,
                regular_spots: 50
              )
            }
            creator_advertiser.company.credits.update_all(amount: bookings[0].total_booking_cost)
            fail_occurred = false
            threads = concurrency_level.times.map do |i|
              Thread.new do
                begin
                  Current.set(user: creator_advertiser) { bookings[i].book }
                rescue Spot::Booking::InsufficentCredits
                  fail_occurred = true
                end
              end
            end
            threads.each(&:join)
            expect(fail_occurred).to eq(true)
            expect(creator_advertiser.company.spots.sum(:count)).to eq(50)
            expect(creator_advertiser.company.credits.sum(:amount)).to eq(0.0)
          ensure
            ActiveRecord::Base.connection_pool.disconnect!
          end
        end
      end
    end
  end
end
