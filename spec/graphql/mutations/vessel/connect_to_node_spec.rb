# frozen_string_literal: true

require 'rails_helper'

describe Mutations::Vessels::ConnectToNode do
  describe '.resolve' do
    include_context 'creator'

    let(:vehicle) do
      Current.set(user: creator_fleet_operator) {
        create(:vehicle, fcm_notification_token: nil)
      }
    end

    context 'successful pairing' do
      it 'tags the vehicle as successfully paired' do
        context  = {}
        resolver = described_class.new(object: nil, context: context, field: nil)
        paired = resolver.resolve(
          vessel_id: vehicle.vessel.id,
          fcm_notification_token: 'foobar'
        )
        expect(paired).to be(true)
        vehicle.reload
        expect(vehicle.fcm_notification_token).to eq('foobar')
      end

      it 'sends notifications' do
        ActiveJob::Base.queue_adapter = :test
        context  = {}
        resolver = described_class.new(object: nil, context: context, field: nil)
        paired = resolver.resolve(
          vessel_id: vehicle.vessel.id,
          fcm_notification_token: 'foobar'
        )
        expect(Vessel::NotifyDownloadVideosJob).to have_been_enqueued
      end
    end
  end
end
