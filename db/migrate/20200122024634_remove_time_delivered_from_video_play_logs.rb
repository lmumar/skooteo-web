class RemoveTimeDeliveredFromVideoPlayLogs < ActiveRecord::Migration[5.2]
  def change
    remove_column :video_play_logs, :time_delivered
  end
end
