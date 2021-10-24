# frozen_string_literal: true

module Fleet
  class VesselWaypointsController < BaseController
    def new
      @waypoint = Waypoint.new sequence: params[:pos].to_i,
        coordinates: params[:coord], name: "waypoint #{params[:pos]}"
      @waypoint.broadcast_append_to Current.user, 'fleet:routes', target: 'waypointset',
        partial: 'fleet/vessel_waypoints/waypoint', locals: { waypoint: @waypoint }
      head :ok
    end
  end
end
