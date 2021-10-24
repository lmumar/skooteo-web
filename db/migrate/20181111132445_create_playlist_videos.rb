class CreatePlaylistVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :playlist_videos do |t|
      t.belongs_to :company
      t.belongs_to :playlist
      t.belongs_to :video
      t.integer :play_order
      t.timestamps
    end
  end
end
