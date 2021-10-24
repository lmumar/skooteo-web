class CreateVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicles do |t|
      t.belongs_to :company
      t.string :type, null: false
      t.jsonb :properties, null: false, default: '{}'
      t.integer :creator_id
      t.timestamps
    end
    add_index :vehicles, :type
    add_index :vehicles, :creator_id
  end
end
