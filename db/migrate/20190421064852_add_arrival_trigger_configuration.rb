class AddArrivalTriggerConfiguration < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicle_routes, :arrival_trigger_in_minutes, :float, default: 0 
  end
end
