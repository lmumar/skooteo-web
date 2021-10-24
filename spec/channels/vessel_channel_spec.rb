# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VesselChannel, type: :channel do
  context 'subscription' do
    context 'vessel id provided' do
      before { subscribe id: 1 }

      it 'subscribes connection to a stream' do
        expect(subscription).to be_confirmed
      end

      it 'has a valid stream' do
        expect(subscription).to have_stream_from('vessel_1')
      end
    end

    context 'vessel id not provided' do
      it 'rejects connection to a stream' do
        subscribe
        expect(subscription).to be_rejected
      end
    end
  end
end
