# frozen_string_literal: true

class Video < ApplicationRecord
  include Const
  include HasCreator
  include HasFinder
  include Eventable

  const types: %w[advertisement announcement entertainment]
  const channels: %w[general movies concert music_videos]

  enum status: [:pending, :approved, :rejected, :screened]

  has_many :playlist_videos
  has_many :playlists, through: :playlist_videos

  has_one_attached :content

  belongs_to :company

  validates :name, presence: true
  validates :video_type, inclusion: { in: types.all }

  before_validation :assign_video_type, unless: Proc.new { |video| video.video_type.present? }

  scope :order_latest,    -> { order updated_at: :desc }
  scope :playable,        -> { where('expire_at IS NULL OR expire_at > ?', Time.current) }
  scope :without_expiry,  -> { where expire_at: nil }
  scope :with_video_type, -> (video_type) { where video_type: video_type }

  delegate :advertiser?, to: :company

  def self.selections(company, playlist)
    if company.advertiser?
      playlist.default? ? company.videos.approved.without_expiry : company.videos.approved
    else
      playlist.channel.present? ? company.videos.playable.entertainment :
        company.videos.approved.playable.announcement
    end
  end

  def approve!
    transaction do
      approved!

      if advertiser?
        playlist = company.playlists.default.first
        # add this video to the default playlist of the advertiser if it's empty.
        playlist.playlist_videos.create!(video: self) if playlist.videos.empty?
      end
    end
  end

  def duration_in_seconds
    (ActiveStorage::Analyzer::VideoAnalyzer.new(content).metadata[:duration] || 0.0).round
  end

  def consumable_spot_count
    (self.duration_in_seconds / Spot.video_durations.in_seconds.to_f).ceil
  end

  types.all.each do |t|
    scope t.to_sym, -> { where(video_type: t) }

    define_method "#{t}?" do
      video_type == t
    end
  end

  private
    def assign_video_type
      self.video_type = (self.creator&.role&.advertiser? || self.company.advertiser?) ?
        types.advertisement : types.entertainment
    end
end
