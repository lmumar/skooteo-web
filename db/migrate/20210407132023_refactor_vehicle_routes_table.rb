# frozen_string_literal: true

class RefactorVehicleRoutesTable < ActiveRecord::Migration[6.1]
  def change
    change_table :vehicle_routes do |t|
      t.remove_index %i[route_type route_id]
      t.index :route_id
      t.index [:vehicle_id, :route_id], unique: true
      t.remove :route_type,
        :estimated_travel_duration_in_minutes,
        :time_allotted_for_regular_ads_in_minutes,
        :time_allotted_for_premium_ads_in_minutes,
        :regular_ads_segment_length_in_minutes,
        :premium_ads_segment_length_in_minutes,
        :time_allotted_for_onboarding_in_minutes,
        :time_allotted_for_offboarding_in_minutes,
        :arrival_trigger_in_minutes
      t.float :estimated_travel_time, default: 0
    end
  end
end
