class AddVideoLogsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :video_play_logs do |t|
      t.belongs_to :time_slot
      t.belongs_to :campaign
      t.belongs_to :video
      t.belongs_to :vehicle
      t.datetime :time_delivered
      t.st_point :lonlat, geographic: true
    end
  end
end
