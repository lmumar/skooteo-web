class AddPlaySequencesRelatedTables < ActiveRecord::Migration[5.2]
  def change
    create_table :play_sequences do |t|
      t.belongs_to :vehicle
      t.integer :time_slot_id
      t.timestamps
      t.index :time_slot_id, unique: true
    end

    create_table :play_sequence_videos do |t|
      t.belongs_to :play_sequence
      t.belongs_to :video
      t.belongs_to :playlist
      t.integer :segment, null: false
      t.string :segment_type, limit: 11, null: false
      t.integer :segment_order, null: false
      t.timestamps
    end
  end
end
