class AddTypeToPlaylists < ActiveRecord::Migration[5.2]
  def change
    add_column :playlists, :type, :string, default: 'Playlist'
    add_index :playlists, :type
  end
end
