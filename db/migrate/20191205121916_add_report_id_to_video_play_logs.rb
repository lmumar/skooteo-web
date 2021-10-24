# frozen_string_literal: true

class AddReportIdToVideoPlayLogs < ActiveRecord::Migration[5.2]
  def change
    change_table :video_play_logs do |t|
      t.bigint :report_id, default: 0
      t.index [:trip_log_id, :vehicle_id, :video_id, :report_id], name: 'ix_video_play_logs_extract'
    end
  end
end
