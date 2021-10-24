module Types
  class WaypointType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :sequence, Integer, null: false
    field :lonlat, Types::LocationType, null: false
  end
end
