class AddChannelToPlaylists < ActiveRecord::Migration[5.2]
  def change
    add_column :playlists, :channel, :string
    add_index :playlists, :channel
  end
end
