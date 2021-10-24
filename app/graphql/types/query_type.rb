# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :announcement_videos, resolver: Queries::AnnouncementVideos
    field :entertainment_videos, resolver: Queries::EntertainmentVideos
    field :fleet_operator, resolver: Queries::FleetOperator
    field :fleet_operators, resolver: Queries::FleetOperators
    field :vessel, resolver: Queries::Vessel
    field :vessel_by_device_token, resolver: Queries::VesselByDeviceToken
    field :vessels, resolver: Queries::Vessels
    field :video, resolver: Queries::Video
    field :video_by_ids, resolver: Queries::VideoByIds
    field :route, resolver: Queries::Routes
    field :trips, resolver: Queries::Trips
    field :trip,  resolver: Queries::Trip
    field :trip_playlist, resolver: Queries::TripPlaylist
  end
end
