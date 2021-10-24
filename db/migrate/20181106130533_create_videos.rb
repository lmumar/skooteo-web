class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.string :name, null: false
      t.integer :status, index: true
      t.datetime :expire_at
      t.belongs_to :company
      t.belongs_to :creator
      t.timestamps
    end
    add_index :videos, :name, opclass: :gin_trgm_ops, using: :gin
  end
end
