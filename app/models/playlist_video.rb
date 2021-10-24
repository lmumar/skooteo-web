# frozen_string_literal: true

class PlaylistVideo < ApplicationRecord
  belongs_to :company, optional: true
  belongs_to :playlist, touch: true
  belongs_to :video

  delegate :duration_in_seconds, :content, :consumable_spot_count, to: :video

  after_create_commit :assign_playorder

  #  TODO
  # after_destroy do |playlist_video|
  #   # touch playlist to trigger sequencing
  #   playlist_video.playlist.touch
  # end

  private
    def assign_playorder
      result = RecordSequence.next(self.playlist)
      self.play_order = result[0]['seq']
      save
    end
end
