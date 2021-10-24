class AddSpotsRelatedFieldsToRoutes < ActiveRecord::Migration[5.2]
  def change
    add_column :routes, :estimated_travel_duration_in_minutes, :float
    add_column :routes, :time_allotted_for_regular_ads_in_minutes, :float
    add_column :routes, :time_allotted_for_premium_ads_in_minutes, :float
    add_column :routes, :regular_ads_segment_length_in_minutes, :float
    add_column :routes, :premium_ads_segment_length_in_minutes, :float
  end
end
