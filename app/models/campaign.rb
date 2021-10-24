# frozen_string_literal: true

class Campaign < ApplicationRecord
  belongs_to :company
  belongs_to :advertiser, class_name: "User", foreign_key: "advertiser_id"

  has_many :spots

  scope :incoming, -> { where('start_date >= ?', Date.today) }

  def has_started?
    self.start_date <= Date.today
  end
end
