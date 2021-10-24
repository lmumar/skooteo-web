class AddStatusToPlaySequences < ActiveRecord::Migration[5.2]
  def change
    add_column :play_sequences, :status, :integer, default: 0
    add_index :play_sequences, :status
  end
end
