# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VehicleRouteSchedule::Template, type: :model do
  describe '.schedules' do
    include_context 'creator'

    it 'generates valid etd eta pair' do
      Current.set(user: creator) do
        vr = create(:vehicle_route)
        vr.estimated_travel_duration = 2.hours + 30.minutes
        vr.save!

        esd = Date.current.beginning_of_week
        eed = 1.days.since(esd)

        expected = [[
          esd.strftime('%Y-%d-%m') + ' 23:00',
          1.day.since(esd).strftime('%Y-%d-%m') + ' 01:30'
        ], [
          eed.strftime('%Y-%d-%m') + ' 23:00',
          1.day.since(eed).strftime('%Y-%d-%m') + ' 01:30'
        ]]

        vst = VehicleRouteSchedule::Template.new(
          effective_start_date: esd.to_s,
          effective_end_date: eed.to_s,
          days: { '1' => '1', '2' => '2' },
          td: '23:00'
        )
        generated = []
        format = '%Y-%d-%m %H:%M'
        vst.schedules(vr) { |etd, eta|
          generated << [etd.strftime(format), eta.strftime(format)]
        }
        expect(expected).to eq(generated)
      end
    end
  end
end
