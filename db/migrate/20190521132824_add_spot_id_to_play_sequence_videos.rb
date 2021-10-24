class AddSpotIdToPlaySequenceVideos < ActiveRecord::Migration[5.2]
  def change
    change_table(:play_sequence_videos) do |t|
      t.belongs_to :spot
    end
  end
end
