# frozen_string_literal: true

class VehicleRoute < ApplicationRecord
  include Eventable
  include HasCreator
  include SpotConfigurations
  include WithDurationFields

  enum status: [ :active, :inactive ]

  has_many :vehicle_route_schedules, dependent: :destroy

  belongs_to :route
  belongs_to :vehicle

  has_one :company, through: :route
  has_one :media_setting

  # after_commit :recompute_boarding_duration, on: [:create]

  delegate :name, :origin, :destination, to: :route, prefix: true

  default_scope { includes(:media_setting).active }

  to_duration_field estimated_travel_time: :estimated_travel_duration

  delegate :regular_ads_duration, :premium_ads_duration, :regular_ads_segment_duration, :premium_ads_segment_duration,
    :onboarding_duration, :offboarding_duration, :arrival_trigger_duration, to: :media_setting

  class << self
    def ensure_unique_existence!(vehicle, route)
      transaction do
        results = upsert({ vehicle_id: vehicle.id, route_id: route.id, creator_id: Current.user.id,
          created_at: Time.current, updated_at: Time.current },
          unique_by: :index_vehicle_routes_on_vehicle_id_and_route_id)
        MediaSetting.upsert({ vehicle_route_id: results.first['id'], created_at: Time.current, updated_at: Time.current },
          unique_by: :index_media_settings_on_vehicle_route_id)
      end
    end
  end

  def update_from_params(attribs = {})
    form = Form.new attribs
    transaction do
      form.set(self)
      save!
      media_setting.save!
    end
  end

  def regular_ads_segment_count
    (regular_ads_duration.in_seconds / regular_ads_segment_duration.in_seconds).round
  end

  def premium_ads_segment_count
    (premium_ads_duration.in_seconds / premium_ads_segment_duration.in_seconds).round
  end

  # def available_regular_spots
  #   (self.time_allotted_for_regular_ads_in_seconds / Skooteo::SPOT_VIDEO_DURATION_IN_SEC).round
  # end

  # def available_premium_spots
  #   (self.time_allotted_for_premium_ads_in_seconds / Skooteo::SPOT_VIDEO_DURATION_IN_SEC).round
  # end

  # def estimated_travel_duration_in_seconds
  #   (self.estimated_travel_duration_in_minutes || 0) * 60
  # end

  # def regular_ads_segment_length_in_seconds
  #   (self.regular_ads_segment_length_in_minutes || 0) * 60
  # end

  # def premium_ads_segment_length_in_seconds
  #   (self.premium_ads_segment_length_in_minutes || 0) * 60
  # end

  # def time_allotted_for_regular_ads_in_seconds
  #   (self.time_allotted_for_regular_ads_in_minutes || 0) * 60
  # end

  # def time_allotted_for_premium_ads_in_seconds
  #   (self.time_allotted_for_premium_ads_in_minutes || 0) * 60
  # end

  # private
  #   def recompute_boarding_duration
  #     service = VesselRouteServices::BoardingDurationUpdate.new(object: self)
  #     service.call
  #   end
end
