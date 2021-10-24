# frozen_string_literal: true

class Company < ApplicationRecord
  include Const
  include Eventable
  include HasFinder

  const types: [ :skooteo, :advertiser, :fleet_operator, :content_provider ]
  enum company_type: types.all

  has_many :company_addons
  accepts_nested_attributes_for :company_addons, allow_destroy: true,
    reject_if: proc { |attributes| attributes['addon_id'] == '0' }

  has_many :addons, through: :company_addons do
    def enabled?(addon_code)
      exists?(code: addon_code)
    end
  end

  has_many :campaigns

  has_many :credits do
    def topup!(amount, transactor, particulars = 'Additional credits')
      create!(
        transaction_code: 'credits_added', amount: amount,
        recorder: transactor, particulars: particulars)
    end

    def spend!(campaign, amount, transactor, particulars = 'Booked spot')
      create!(
        transaction_code: 'booked_spot', amount: amount * -1,
        campaign: campaign, recorder: transactor, particulars: particulars)
    end

    def system_refund!(campaign, amount, transactor, particulars = 'System refund')
      create!(
        transaction_code: 'system_refund', amount: amount,
        campaign: campaign, recorder: transactor, particulars: particulars)
    end
  end

  has_many :routes
  has_many :users
  has_many :vehicles, dependent: :destroy
  has_many :vessels, -> { where vehicleable_type: 'Vessel' }, class_name: 'Vehicle'
  has_many :vehicle_routes, through: :vehicles
  has_many :vehicle_route_schedules, through: :vehicle_routes
  has_many :videos
  has_many :playlists
  has_many :time_slots
  has_many :spots, through: :campaigns

  has_one :system_account, -> { where no_login: true }, class_name: 'User'

  validates :name, :company_type, :time_zone, presence: true

  after_create_commit :post_setup

  scope :non_demo, -> { where demo: false }

  def can_book?
    credits.sum(&:amount) > 0 && videos.count > 0
  end

  private
    def post_setup
      creator = create_nologin_account
      Current.set(user: creator) { create_default_channels }
    end

    def create_default_channels
      if self.fleet_operator?
        Video.channels.all.each do |channel|
          self.playlists.create!(
            name: channel.humanize,
            channel: channel,
            status: Playlist.statuses[:active]
          )
        end
      elsif self.advertiser?
        playlists.create!(name: 'Default', status: 'default')
      end
    end

    # nologin accounts will be the proxy user used by the
    # system for vessels that authenticate using the device token
    def create_nologin_account
      User.create_nologin_account(self)
    end
end
