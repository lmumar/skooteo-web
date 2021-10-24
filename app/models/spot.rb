# frozen_string_literal: true

class Spot < ApplicationRecord
  include Const

  belongs_to :campaign, optional: true
  belongs_to :time_slot
  belongs_to :vehicle_route_schedule
  belongs_to :route
  belongs_to :playlist, optional: true, touch: true
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"

  has_one :company, through: :campaign

  validates :type, :count, :cost_per_cpm, presence: true

  self.inheritance_column = nil

  const video_durations: { in_seconds: 15 }
  const per_impression: { count: 1_000 }
  const types: %w[regular premium]
  const cpms: { premium: 1.25, regular: 1.0 }

  scope :regular, -> { where(type: types.regular) }
  scope :premium, -> { where(type: types.premium) }

  def self.compute_booking_cost(spots, credits_per_spot)
    spots * credits_per_spot
  end

  def premium?
    self.type == types.premium
  end

  def regular?
    !premium?
  end
end
