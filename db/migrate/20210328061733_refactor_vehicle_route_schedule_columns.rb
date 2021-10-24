# frozen_string_literal: true

class RefactorVehicleRouteScheduleColumns < ActiveRecord::Migration[6.1]
  def change
    change_table :vehicle_route_schedules do |t|
      t.remove :wday, :type, :effective_start_date, :effective_end_date, :etd, :eta
    end
    change_table :vehicle_route_schedules do |t|
      t.datetime :etd, null: false, index: true
      t.datetime :eta, null: false, index: true
      t.index [:vehicle_route_id, :etd], unique: true, name: 'i_vehicle_route_id_and_etd'
    end
  end
end
