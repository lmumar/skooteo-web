# frozen_string_literal: true

class RefactorRoutesTable < ActiveRecord::Migration[6.1]
  def change
    change_table :routes do |t|
      t.remove :estimated_travel_duration_in_minutes,
        :time_allotted_for_regular_ads_in_minutes,
        :time_allotted_for_premium_ads_in_minutes,
        :regular_ads_segment_length_in_minutes,
        :premium_ads_segment_length_in_minutes,
        :type, :first_half_distance
    end
  end
end
