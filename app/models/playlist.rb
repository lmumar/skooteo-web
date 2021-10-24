# frozen_string_literal: true

class Playlist < ApplicationRecord
  include CompanyOwnable
  include Eventable
  include HasCreator

  enum status: [:active, :archived, :default]

  has_many :playlist_videos, dependent: :destroy
  has_many :spots
  has_many :time_slots, through: :spots
  has_many :videos, through: :playlist_videos

  validates :name, presence: true

  # after_commit :schedule_playlist_sequencing, :recompute_boarding_duration, on: [:create, :update]
  # after_touch :schedule_playlist_sequencing, :recompute_boarding_duration

  scope :onboarding, -> { where(type: OnboardingPlaylist.name) }
  scope :offboarding, -> { where(type: OffboardingPlaylist.name) }

  class << self
    def generate(trip)
      Sequencing.new(trip.time_slot).call
    end

    def segment(playlists, segments_count)
      segmenter.call(playlists, segments_count)
    end

    def segmenter
      @segmenter ||= Segmenting.new
    end
  end

  def total_duration_in_minutes
    self.videos.playable.sum(&:duration_in_seconds) / 60.0
  end

  # sets the current playlist as the default and return the
  # previous default playlist
  def set_default!
    default_playlist = company.playlists.default.where(type: type).first
    transaction do
      # remove *default* status of other playlists of the same type from the company
      # and make the passed playlist the default
      default_playlist&.active!
      default!
    end
    default_playlist
  end

  def switch_playorder!(switched_playlist_video, location)
    ordered = playlist_videos.order(:play_order)
    transaction do
      playlist_video_at_location = ordered[location]
      playlist_video_at_location.play_order, switched_playlist_video.play_order =
        switched_playlist_video.play_order, playlist_video_at_location.play_order
      playlist_video_at_location.save!
      switched_playlist_video.save!
    end
  end

  # TODO:
  # private
  # def schedule_playlist_sequencing
  #   # only non-demo advertiser's playlist can be sequenced
  #   if self.type == Playlist.name && self.company.advertiser? && !self.company.demo?
  #     SequencerJob.perform_later self.id
  #   end
  # end

  # def recompute_boarding_duration
  #   return unless [OnboardingPlaylist.name, OffboardingPlaylist.name].include?(self.type)
  #   self.company.vehicle_route_ids.each do |record_id|
  #     ComputeOnoffboardingDurationJob.perform_later(record_id, creator_id)
  #   end
  # end
end
