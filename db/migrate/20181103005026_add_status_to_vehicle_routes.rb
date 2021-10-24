class AddStatusToVehicleRoutes < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicle_routes, :status, :integer, default: 0
    add_index :vehicle_routes, :status
  end
end
