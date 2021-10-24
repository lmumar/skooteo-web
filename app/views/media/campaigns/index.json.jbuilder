# frozen_string_literal: true

json.array! @campaign_search.results.each do |campaign|
  json.id campaign.id
  json.name campaign.name
  json.start_date campaign.start_date
  json.end_date campaign.end_date
  json.has_default_playlists campaign.spots.all? { |spot| spot.playlist&.default? }
  json.has_playlists campaign.spots.any? { |spot| spot.playlist }
  json.spots campaign.spots.sort { |sp1, sp2| sp1.vehicle_route_schedule.etd <=> sp2.vehicle_route_schedule.etd } do |spot|
    json.id spot.id
    json.vessel_name spot.time_slot.vehicle.name
    json.trip_date spot.vehicle_route_schedule.etd.strftime '%Y-%m-%d'
    json.time_slot_id spot.time_slot.id
    json.campaign_id spot.campaign_id
    json.etd spot.vehicle_route_schedule.etd
    json.eta spot.vehicle_route_schedule.eta
    json.route_id spot.route_id
    json.route_name spot.route.name
    json.spot_count spot.count
    json.spot_type spot.type
  end
end
