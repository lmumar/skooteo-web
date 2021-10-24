# frozen_string_literal: true

class AddConnectedToNodeField < ActiveRecord::Migration[6.1]
  def change
    add_column :vehicles, :connected_to_node_at, :datetime
  end
end
