module Types
  class MutationType < Types::BaseObject
    field :create_trip_log, mutation: Mutations::CreateTripLog
    field :connect_to_node, mutation: Mutations::Vessels::ConnectToNode
    field :disconnect_from_node, mutation: Mutations::Vessels::DisconnectFromNode
  end
end
