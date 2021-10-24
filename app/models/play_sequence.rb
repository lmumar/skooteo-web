# frozen_string_literal: true
class PlaySequence < ApplicationRecord
  enum status: [ :sequencing, :sequenced ]

  has_many :play_sequence_videos

  belongs_to :time_slot
  belongs_to :vehicle
end
