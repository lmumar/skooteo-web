# frozen_string_literal: true

class CreateMediaSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :media_settings do |t|
      t.belongs_to :vehicle_route
      t.integer :regular_ads_length,
        :regular_ads_segment_length,
        :premium_ads_length,
        :premium_ads_segment_length,
        :onboarding_length,
        :offboarding_length,
        :arrival_trigger_time, default: 0
      t.timestamps
    end
  end
end
