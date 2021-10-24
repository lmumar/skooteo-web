# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  include_context 'creator'

  context 'connect using authorization header' do
    let(:vehicle) do
      Current.set(user: creator_fleet_operator) {
        create(:vehicle)
      }
    end

    before { connect "/cable", headers: { "Authorization" => vehicle.device_token } }

    it 'successfully connects' do
      expect(connection.current_user.id).to eq creator_fleet_operator.company.system_account.id
    end

    it 'sets current vehicle' do
      expect(Current.vehicle).to eq(vehicle)
    end
  end

  context 'connect using cookies' do
    it 'successfully connects' do
      Current.set(user: creator_fleet_operator) do
        cookies.encrypted[:user_id] = Current.user.id
        connect "/cable"
        expect(connection.current_user.id).to eq Current.user.id
      end
    end
  end
end
