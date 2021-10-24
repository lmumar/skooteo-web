class CreateRoutes < ActiveRecord::Migration[5.2]
  def change
    create_table :routes do |t|
      t.belongs_to :company
      t.string :name, null: false
      t.float :distance, null: false
      t.string :origin, :destination, null: false
      t.integer :creator_id, null: false
      t.timestamps
    end
    add_index :routes, :name, opclass: :gin_trgm_ops, using: :gin
    add_index :routes, :creator_id
  end
end
