# frozen_string_literal: true

class VideoPlayLog < ApplicationRecord
  belongs_to :time_slot, optional: true
  belongs_to :campaign, optional: true
  belongs_to :trip_log, optional: true
  belongs_to :video
  belongs_to :vehicle
  belongs_to :spot, optional: true

  # FIXME: Change this to advertising_company since
  # the video_playlog support logs from advertiser and
  # fleet operator videos
  has_one :company, through: :video

  validates :trip_etd, :trip_eta, :video_type, presence: true
end
