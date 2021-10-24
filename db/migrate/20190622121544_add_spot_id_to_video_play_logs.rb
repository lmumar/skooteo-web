class AddSpotIdToVideoPlayLogs < ActiveRecord::Migration[5.2]
  def change
    change_table(:video_play_logs) do |t|
      t.belongs_to :spot
    end
  end
end
