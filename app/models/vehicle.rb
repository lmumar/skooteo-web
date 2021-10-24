# frozen_string_literal: true

class Vehicle < ApplicationRecord
  include CompanyOwnable
  include HasCreator
  include WithInitials

  enum status: [ :pre_deployment, :active_service, :under_maintenance, :decommissioned ]

  has_many :vehicle_routes, dependent: :destroy
  has_many :vehicle_route_schedules, through: :vehicle_routes
  has_many :routes, through: :vehicle_routes
  has_many :time_slots
  has_many :play_sequences

  has_one_attached :image

  accepts_nested_attributes_for :vehicle_routes,
      reject_if: ->(attributes) { attributes['route_id'].blank? }

  has_secure_token :device_token

  validates :image, content_type: ["image/png", "image/jpeg"]

  delegated_type :vehicleable, types: %w[ Vessel ]

  after_create_commit :generate_default_avatar, unless: Proc.new { Rails.env.test? }

  private
    def generate_default_avatar
      return if image.attached?
      path = Skooteo::Avatar::Letter.generate(letters: initials)
      image.attach(
        io: File.open(path),
        filename: 'avatar.jpg',
        content_type: 'image/jpeg',
        identify: false
      )
    end
end
