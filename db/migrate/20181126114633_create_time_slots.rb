class CreateTimeSlots < ActiveRecord::Migration[5.2]
  def up
    create_table :time_slots do |t|
      t.belongs_to :vehicle
      t.belongs_to :company
      t.belongs_to :vehicle_route_schedule
      t.belongs_to :route
      t.datetime   :etd, :eta
      t.integer :available_regular_spots, :available_premium_spots, default: 0
      t.timestamps
    end
    execute 'CREATE UNIQUE INDEX idx_timeslots_vehicle_route_schedule_etd ON time_slots (vehicle_route_schedule_id, (etd::DATE));'
  end

  def down
    drop_table :time_slots
  end
end
