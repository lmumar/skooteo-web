# frozen_string_literal: true

class UpdateTripLogsForFleetOpReporting < ActiveRecord::Migration[5.2]
  def change
    change_table(:trip_logs) do |t|
      t.references :vehicle
      t.datetime :trip_etd, :trip_eta
      t.index [:vehicle_id, :trip_etd, :trip_eta]
    end
  end
end
