class CreateWaypoints < ActiveRecord::Migration[5.2]
  def change
    create_table :waypoints do |t|
      t.belongs_to :route
      t.string :name, null: false
      t.integer :sequence
      t.st_point :lonlat, geographic: true
      t.timestamps
    end
    add_index :waypoints, :name, opclass: :gin_trgm_ops, using: :gin
    add_index :waypoints, :lonlat, using: :gist
  end
end
