class AddTripLogIdToVideoPlayLogs < ActiveRecord::Migration[5.2]
  def change
    change_table :video_play_logs do |t|
      t.belongs_to :trip_log
      t.integer :segment, :segment_order
    end
  end
end
