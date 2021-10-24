## Data models

* Bold fields are required

### users
* **id**
* **company_id**
* **email**
* **password**

### people
* **id**
* **user_id**
* **first_name**
* **last_name**

### companies
* **id**
* **name**
* **company_type** (advertiser, fleet_operator)

### credits
* **id**
* **company_id**
* **transaction_code**
* **amount**
* particulars
* **recorder_id**

### time_slots
- **id**
- **vehicle_id**
- **company_id**
- **vehicle_route_schedule_id**
- **route_id**
- **eta**
- **etd**
- **available_regular_spots** - the value here is dependent on the value of the vehicle_routes
- **available_premium_spots**

Time slots should be indexed uniquely based on the following fields:
* vehicle_id
* route_id
* etd

Initial calculation of spots
available_regular_spots = vehicle_routes#time_allotted_for_regular_ads_in_minutes/vehicle_routes#regular_ads_segment_length_in_minutes
available_premium_spots = vehicle_routes#time_allotted_for_premium_ads_in_minutes/vehicle_routes#premium_ads_segment_length_in_minutes


Timeslots should be created atomically and on demand.

### campaigns
- **id**
- **company_id**
- **name**
- **advertiser_id**
- **start_date**
- **end_date**

### spots
- **id**
- **type** - (RegularSpot, PremiumSpot)
- **time_slot_id**
- **campaign_id**
- **playlist_id**
- **vehicle_route_schedule_id**
- **route_id**
- **count**
- **cost_per_cpm**

The events table will record interesting events related to a model. Example, changing of a status of a video from pending - approved. The
action will be `status_changed` and the details is a jsonb which contains additional information example:
```
{ previous_status: 'pending', current_status: 'approved' }
```
### events
- **id**
- **recordable_id**
- **recordable_type**
- **action**
- **details**
- **creator_id**

### videos
- **id**
- **name**
- **expire_at**
- **status** - (pending, approved, rejected)
- **default** - if true and the company haven't added any videos yet, during sequencing the server will use the default video of to play for their ads.
- **creator_id**
- **company_id**

### playlists
- **id**
- **company_id**
- **name**
- **status** (active, archived)
- **creator_id**

### playlist_videos
- **id**
- **playlist_id**
- **video_id**
- **play_order**

### play_sequences
- **id**
- **time_slot_id** - should be unique
- **vehicle_id**

### play_sequence_videos
- **id**
- **play_sequence_id**
- **video_id**
- **playlist_id**
- **segment** - which segment the video should be played, integer
- **segment_type** - type of segment (regular or premium)
- **segment_order** - order within the segment the video should be played, integer

### roles
* **id**
* **name**
* **code**

### user_roles
* **id**
* **user_id**
* **role_id**
* **grantor_id**

### routes
* **id**
* **name**
* **distance**
* **origin** - place of origin
* **destination** - place of destination
* **company_id** - the vehicle company that created this route
* **creator_id** - the user who created this route
* **estimated_travel_duration_in_minutes** - can be overriden in vehicle_routes
* **time_allotted_for_regular_ads_in_minutes** - can be overriden in vehicle_routes
* **time_allotted_for_premium_ads_in_minutes** - can be overriden in vehicle_routes
* **regular_ads_segment_length_in_minutes** - can be overriden in vehicle_routes
* **premium_ads_segment_length_in_minutes** - can be overriden in vehicle_routes
* **type** - route type (VesselRoute, BusRoute)

### waypoints
* **id**
* **name**
* **route_id**
* **sequence** - the order/sequence of the waypoint
* **latitude**
* **longitue**
Note: to find the origin and destination waypoint just sort the waypoints by sequence, then get the first and last. Example:
```
ordered = route.waypoints.order(&:sequence)
origin  = ordered.first
destination = ordered.last
```

### vehicles
* **id**
* **type** - possible values Bus, Vessel
* **company_id**
* **properties** - jsonb properties of a vehicle (https://nandovieira.com/using-postgresql-and-jsonb-with-ruby-on-rails)

example migration
```
create_table :vehicles do |t|
  t.string :type, null: false
  t.jsonb  :properties, null: false, default: '{}'
  t.timestamp
end
```

example activerecord representation
```
class Vehicle < ApplicationRecord
  serialize :properties, PropSerializer

  class PropSerializer
    def self.dump props
      props.to_json
    end

    def self.load hash
      (hash || {}).with_indifferent_access
    end
  end
end

class Vessel < Vehicle
  store_accessor :properties, :name, :capacity
end

island1 = Vessel.new name: 'Island Express 1', capacity: 100
island2 = Vessel.where("properties -> 'name' ? :name", name: 'Island Express 2')
```

### vehicle_routes
* **id**
* **vehicle_id**
* **route_id**
* **estimated_travel_duration_in_minutes**
* **time_allotted_for_regular_ads_in_minutes**
* **time_allotted_for_premium_ads_in_minutes**
* **regular_ads_segment_length_in_minutes**
* **premium_ads_segment_length_in_minutes**

### vehicle_route_schedules
* **id**
* **route_id**
* **vehicle_route_id**
* **vehicle_id** - convenience field to access vehicles directly
* **route_id**   - convenience field to access route directly
* **day_of_week** (0 - Sunday ... 6 - Saturday)
* **etd** (military time)
* **eta** (military time)

## tags
* **id**
* **name**

## taggables
* **id**
* **tag_id**
* **taggable_id**
* **taggable_type**

Permission will be handled in code using access_granted gem.
https://github.com/chaps-io/access-granted
