class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :recordable_id, null: false
      t.string  :recordable_type, null: false
      t.string  :action, null: false
      t.string  :details
      t.integer :creator_id, null: false
      t.timestamps
    end
    add_index :events, [:recordable_id, :recordable_type]
    add_index :events, :action
    add_index :events, :creator_id
  end
end
