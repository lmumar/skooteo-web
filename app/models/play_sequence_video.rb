# frozen_string_literal: true

class PlaySequenceVideo < ApplicationRecord
  belongs_to :play_sequence
  belongs_to :video
  belongs_to :spot
  belongs_to :playlist
end
