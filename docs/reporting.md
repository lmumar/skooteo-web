## JSON data structure

Trip info JSON
```
{
  vessel_id: 4
  time_slot_id: 2
  status: 2 # complete: 2, ongoing: 1, pending: 0,
  date: 2019-05-21,
  etd: 05:15:00,
  eta: 08:15:00,
  segments: { # exactly same ra kung unsa naa sa firebase
    {
      "status": 0,
      "created": 1557971348016,
      "premium": {
        "sequence": [null, null, 23, 11, null, 16], # if null siya meaning na deliver ang video
        "segment_duration": 3.0,
        "actual_segment_duration": 3.0
      },
     "regular": {
        "sequence": [[null, 23], [null, null], [null, 56], [37], [37], [37]], # if null siya meaning na deliver ang video
        "segment_duration": 3.0},
        "video_ids": [37]
     }
  },
  ata: 05:15:00,
  atd: 08:20:00,
  actual_duration: 03:05:00
}
```

Video info JSON

```
{
  vessel_id: 4,
  video_id: 1
  time_slot_id: 2,
  start: 05:30:00,
  end: 05:31:00,
  video_type: "advertisement",
  notes: "delivered"
  coordinates: {lat: 123.343, lng: 10.343},
  eta: 123, # minutes
  destination_distance: 12345, # meters
  origin_distance: 1234, # meters
  video_position_in_segment: 1,
  segment_position: 2,
  segment_type: "regular"
}
```