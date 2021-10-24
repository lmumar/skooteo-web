# frozen_string_literal: true

class RefactorTimeSlots < ActiveRecord::Migration[6.1]
  def change
    remove_index :time_slots, name: 'index_time_slots_on_vehicle_route_schedule_id'
    remove_index :time_slots, name: 'idx_timeslots_vehicle_route_schedule_etd'
    change_table :time_slots do |t|
      t.remove :etd, :eta
      t.index :vehicle_route_schedule_id, unique: true
    end
  end
end
