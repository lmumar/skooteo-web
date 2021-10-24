class AddRouteIdToVehicleRouteSchedules < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicle_route_schedules, :route_id, :integer
    add_index :vehicle_route_schedules, :route_id
  end
end
