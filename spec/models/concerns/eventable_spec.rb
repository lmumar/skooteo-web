# frozen_string_literal: true

# frozen_string_literal: true

require 'rails_helper'

describe Eventable, type: :model do
  describe '.track_event' do
    context 'when host object is created' do
      include_context 'creator'

      it 'also generates an event record in the database' do
        expect do
          Current.set(user: creator) { Company.create!(name: 'acme corp', time_zone: 'Asia/Manila') }
        end.to change { Event.count }.by(1)
      end
    end
  end
end
