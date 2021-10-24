class AddTypeToRoutes < ActiveRecord::Migration[5.2]
  def change
    add_column :routes, :type, :string, null: false
    add_index :routes, :type
  end
end
