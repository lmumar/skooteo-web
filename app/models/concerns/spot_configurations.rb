# frozen_string_literal: true
module SpotConfigurations
  extend ActiveSupport::Concern

  def total_ads_duration
    self.time_allotted_for_regular_ads_in_minutes +
      self.time_allotted_for_premium_ads_in_minutes
  end

  def total_entertainment_duration
    self.estimated_travel_duration_in_minutes -
      self.total_ads_duration
  end

  def entertainment_percentage
    return 0 if self.estimated_travel_duration_in_minutes.zero?
    (self.total_entertainment_duration/self.estimated_travel_duration_in_minutes) * 100
  end

  def ads_percentage
    return 0 if self.estimated_travel_duration_in_minutes.zero?
    (self.total_ads_duration/self.estimated_travel_duration_in_minutes) * 100
  end
end
