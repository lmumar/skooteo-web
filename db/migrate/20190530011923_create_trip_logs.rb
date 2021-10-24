class CreateTripLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :trip_logs do |t|
      t.belongs_to :time_slot
      t.json :trip_info, :video_info
      t.integer :status, default: 0
      t.string :status_details
      t.timestamps
      t.index :created_at
    end
  end
end
