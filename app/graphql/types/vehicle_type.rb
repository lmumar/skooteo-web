# frozen_string_literal: true

module Types
  class VehicleType < BaseObject
    implements CompanyOwnable

    field :id, ID, null: false
    field :type, Types::VehicleTypes, null: false
    field :name, String, null: false
    field :type, String, null: false
    field :status, Types::VehicleStatuses, null: false

    def type
      object.vehicleable_type
    end
  end
end
