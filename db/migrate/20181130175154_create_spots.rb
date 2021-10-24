class CreateSpots < ActiveRecord::Migration[5.2]
  def change
    create_table :spots do |t|
      t.belongs_to :time_slot
      t.belongs_to :campaign
      t.belongs_to :vehicle_route_schedule
      t.belongs_to :route
      t.belongs_to :playlist
      t.string :type, null: false
      t.integer :count
      t.decimal :cost_per_cpm, precision: 10, scale: 2
      t.integer :creator_id
      t.timestamps
    end
    add_index :spots, :creator_id
  end
end
