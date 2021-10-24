# frozen_string_literal: true

class AddbackFirstHalfDistanceRoutes < ActiveRecord::Migration[6.1]
  def change
    add_column :routes, :first_half_distance, :float, default: 0.0
  end
end
