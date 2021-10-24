class ChangeVehicleRouteScheduleColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :vehicle_route_schedules, :status, :type
  end
end
