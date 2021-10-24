class AddNameAndDeployStatusToVehicles < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicles, :name, :string, null: false
    add_column :vehicles, :status, :integer, default: 0
    add_index :vehicles, :status
    add_index :vehicles, :name, opclass: :gin_trgm_ops, using: :gin
  end
end
