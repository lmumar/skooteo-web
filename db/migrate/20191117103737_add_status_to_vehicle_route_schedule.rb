# frozen_string_literal: true

class AddStatusToVehicleRouteSchedule < ActiveRecord::Migration[5.2]
  def change
    change_table(:vehicle_route_schedules) do |t|
      t.column :status, :integer, default: 0
    end
  end
end
