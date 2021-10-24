class CreateVehicleRoutes < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicle_routes do |t|
      t.belongs_to :vehicle
      t.belongs_to :route, polymorphic: true
      t.float :estimated_travel_duration_in_minutes,
              :time_allotted_for_regular_ads_in_minutes,
              :time_allotted_for_premium_ads_in_minutes,
              :regular_ads_segment_length_in_minutes,
              :premium_ads_segment_length_in_minutes,
              default: 0
      t.integer :creator_id, null: false
      t.timestamps
    end
    add_index :vehicle_routes, :creator_id
  end
end
