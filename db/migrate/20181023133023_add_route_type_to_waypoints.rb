class AddRouteTypeToWaypoints < ActiveRecord::Migration[5.2]
  def change
    add_column :waypoints, :route_type, :string
    add_index :waypoints, [:route_type, :route_id]
  end
end
