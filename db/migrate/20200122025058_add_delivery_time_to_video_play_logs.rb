class AddDeliveryTimeToVideoPlayLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :video_play_logs, :play_start, :datetime
    add_column :video_play_logs, :play_end, :datetime
  end
end
