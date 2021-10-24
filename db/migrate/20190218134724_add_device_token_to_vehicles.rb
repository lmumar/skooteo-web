class AddDeviceTokenToVehicles < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicles, :device_token, :string
    add_index :vehicles, :device_token, unique: true
  end
end
