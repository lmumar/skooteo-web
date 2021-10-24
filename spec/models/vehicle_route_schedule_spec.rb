# frozen_string_literal: true

require 'rails_helper'

describe VehicleRouteSchedule, type: :model do
  include_context 'creator'

  subject { described_class }

  let(:fleet_company) do
    company = nil
    Current.set(user: creator) {
      company = create(:royale_fleet)
    }
    company
  end

  let(:operator) {
    create(:nemo, company: fleet_company)
  }

  let(:media_setting) {
    ms = nil
    Current.set(user: operator) do
      ms = create(:media_setting)
    end
    ms
  }

  context 'creation' do
    it 'automatically creates a time slot' do
      Current.set(user: operator) do
        expect {
          VehicleRouteSchedule.create(
            vehicle_route: media_setting.vehicle_route,
            route: media_setting.vehicle_route.route,
            status: VehicleRouteSchedule.statuses[:active],
            etd: Time.current,
            eta: 2.hours.since
          )
        }.to change { VehicleRouteSchedule.count }.by(1)
          .and change { TimeSlot.count }.by(1)
          .and change { Event.where(recordable_type: 'VehicleRouteSchedule').count }.by(1)
      end
    end

    it 'notifies subscribed vessels of the new schedule' do
      Current.set(user: operator) do
        expect(Vessel::NotifyScheduleChangesJob)
          .to receive(:perform_later)
          .with(instance_of(Vehicle), instance_of(Integer), 'new_schedule').once
        VehicleRouteSchedule.create(
          vehicle_route: media_setting.vehicle_route,
          route: media_setting.vehicle_route.route,
          status: VehicleRouteSchedule.statuses[:active],
          etd: Time.current,
          eta: 2.hours.since
        )
      end
    end

    context 'vessel notification' do
      let!(:schedule) do
        Current.set(user: operator) do
          VehicleRouteSchedule.create(
            vehicle_route: media_setting.vehicle_route,
            route: media_setting.vehicle_route.route,
            status: VehicleRouteSchedule.statuses[:active],
            etd: Time.current,
            eta: 2.hours.since
          )
        end
      end

      context 'when schedule updated' do
        it 'sends updated schedule notification' do
          expect(Vessel::NotifyScheduleChangesJob)
            .to receive(:perform_later)
            .with(instance_of(Vehicle), instance_of(Integer), 'updated_schedule').once
          Current.set(user: operator) { schedule.touch }
        end
      end

      context 'when schedule cancelled' do
        it 'sends cancelled schedule notification' do
          expect(Vessel::NotifyScheduleChangesJob)
            .to receive(:perform_later)
            .with(instance_of(Vehicle), instance_of(Integer), 'cancelled_schedule').once
          Current.set(user: operator) { schedule.inactive! }
        end
      end

      context 'when schedule deleted' do
        it 'sends deleted schedule notification' do
          expect(Vessel::NotifyScheduleChangesJob)
            .to receive(:perform_later)
            .with(instance_of(Vehicle), instance_of(Integer), 'deleted_schedule').once
          Current.set(user: operator) { schedule.destroy }
        end
      end
    end
  end
end
