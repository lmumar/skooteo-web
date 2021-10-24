class CreatePlaylists < ActiveRecord::Migration[5.2]
  def change
    create_table :playlists do |t|
      t.belongs_to :company
      t.string :name, null: false
      t.integer :status, index: true
      t.belongs_to :creator
      t.timestamps
    end
    add_index :playlists, :name, opclass: :gin_trgm_ops, using: :gin
  end
end
