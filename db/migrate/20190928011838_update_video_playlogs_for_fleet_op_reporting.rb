# frozen_string_literal: true

class UpdateVideoPlaylogsForFleetOpReporting < ActiveRecord::Migration[5.2]
  def change
    change_table(:video_play_logs) do |t|
      t.string :video_type, null: false, default: ''
      t.datetime :trip_etd, :trip_eta
      t.index [:trip_etd, :trip_eta]
      t.index :video_type
    end
  end
end
