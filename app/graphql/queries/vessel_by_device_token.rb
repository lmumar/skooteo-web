# frozen_string_literal: true

module Queries
  class VesselByDeviceToken < BaseQuery
    argument :device_token, String, required: true

    type Types::VesselType, null: true

    def resolve(device_token:)
      ::Vessel.includes(:vehicle).where(vehicles: { device_token: device_token }).first
    end
  end
end
