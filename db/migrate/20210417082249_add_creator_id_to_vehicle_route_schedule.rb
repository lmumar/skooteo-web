# frozen_string_literal: true

class AddCreatorIdToVehicleRouteSchedule < ActiveRecord::Migration[6.1]
  def change
    change_table :vehicle_route_schedules do |t|
      t.integer :creator_id, null: false, index: true
    end
  end
end
