# frozen_string_literal: true

class AddVehicleableFieldsToVehicles < ActiveRecord::Migration[6.1]
  def up
    change_table :vehicles do |t|
      t.integer :capacity, :vehicleable_id, default: 0
      t.string :vehicleable_type, null: false
      t.index [:vehicleable_type, :vehicleable_id], name: 'ix_vehicleable_id_and_type'

      t.remove :properties
      t.remove :type
    end
  end

  def down
    remove_column :vehicles, :capacity
    remove_column :vehicles, :vehicleable_id
    remove_column :vehicles, :vehicleable_type
    add_column :vehicles, :properties, :jsonb, null: false, default: '{}'
    add_column :vehicles, :type, :string, null: false
  end
end
