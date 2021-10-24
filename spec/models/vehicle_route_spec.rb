# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VehicleRoute, type: :model do
  describe '.ensure_unique_existence!' do
    include_context 'creator'

    it 'creates only one vehicle route and media setting' do
      Current.set(user: creator) do
        vehicle = create(:vehicle)
        route = create(:route)
        expect {
          VehicleRoute.ensure_unique_existence!(vehicle, route)
          VehicleRoute.ensure_unique_existence!(vehicle, route)
          VehicleRoute.ensure_unique_existence!(vehicle, route)
        }.to change { VehicleRoute.count }.by(1)
          .and change { MediaSetting.count }.by(1)
      end
    end
  end
end
