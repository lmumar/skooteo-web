# frozen_string_literal: true

class AddCreditPerSpotToVehicles < ActiveRecord::Migration[6.1]
  def change
    add_column :vehicles, :credits_per_spot, :decimal, default: 1.0
  end
end
