# frozen_string_literal: true

class MakeMediaSettingsVehicleRouteIdUnique < ActiveRecord::Migration[6.1]
  def up
    remove_index :media_settings, name: :index_media_settings_on_vehicle_route_id
    add_index :media_settings, :vehicle_route_id, unique: true
  end

  def down
    remove_index :media_settings, :vehicle_route_id
    add_index :media_settings, :vehicle_route_id, name: :index_media_settings_on_vehicle_route_id
  end
end
