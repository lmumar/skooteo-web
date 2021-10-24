# frozen_string_literal: true

class Route < ApplicationRecord
  include CompanyOwnable
  include HasCreator
  include HasFinder
  include SpotConfigurations

  attribute :first_half_distance, :metric_distance
  attribute :distance, :metric_distance

  has_many :vehicle_routes
  has_many :waypoints, -> { order :sequence }, as: :route, dependent: :delete_all

  validates :name, :origin, :destination, presence: true

  accepts_nested_attributes_for :waypoints, reject_if: ->(attributes) { attributes['name'].blank? }, allow_destroy: true

  before_save do
    self.search_keywords = "%<name>s, %<origin>s, %<destination>s".% [
      name: self.name, origin: self.origin, destination: self.destination
    ]
  end

  before_validation :set_origin_and_destination

  private
    def set_origin_and_destination
      return if self.waypoints.empty?
      self.origin = self.waypoints.first.name
      self.destination = self.waypoints.last.name
    end
end
