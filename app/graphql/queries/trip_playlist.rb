# frozen_string_literal: true

module Queries
  class TripPlaylist < BaseQuery
    description 'Find trip playlist'

    argument :trip_id, ID, required: true
    type String, null: true

    def resolve(trip_id:)
      trip = VehicleRouteSchedule.find(trip_id)
      Playlist.generate(trip)
    end
  end
end
