class CreateVehicleRouteSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicle_route_schedules do |t|
      t.belongs_to :vehicle_route
      t.integer :wday, limit: 1, default: 0, index: true
      t.time :etd, :eta
      t.date :effective_start_date, :effective_end_date, index: true
      t.string :status, index: true
      t.timestamps
    end
  end
end
