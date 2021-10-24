class AddFirstHalfDistanceToRoutes < ActiveRecord::Migration[5.2]
  def change
    add_column :routes, :first_half_distance, :float
  end
end
