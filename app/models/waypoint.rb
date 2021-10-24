# frozen_string_literal: true
class Waypoint < ApplicationRecord
  belongs_to :route, polymorphic: true, optional: true

  validates :name, :lonlat, presence: true

  attr_accessor :coordinates
  attr_accessor :label

  after_find do |waypoint|
    self.coordinates = "(#{waypoint.lonlat.lon}, #{waypoint.lonlat.lat})"
  end

  before_validation :normalize_coordinates, if: Proc.new { |wp| wp.coordinates.present? }

  private

  def normalize_coordinates
    # we need to reverse as data in coordinates is specified as latlng
    self.lonlat = "POINT#{self.coordinates.split(',').join ' '}"
  end
end
