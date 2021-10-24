# frozen_string_literal: true

class AddStatusTextToVehicleRouteSchedules < ActiveRecord::Migration[6.1]
  def change
    change_table :vehicle_route_schedules do |t|
      t.text :status_text, null: true
    end
  end
end
