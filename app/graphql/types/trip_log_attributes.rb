# frozen_string_literal: true

class Types::TripLogAttributes < Types::BaseInputObject
  description "Attributes for creating or updating trip log"
  argument :time_slot_id, ID, "unique time slot id", required: false
  argument :trip_info, String, "JSON data that contains trip information", required: false
  argument :video_info, String, "JSON data that contains video information", required: false
end
