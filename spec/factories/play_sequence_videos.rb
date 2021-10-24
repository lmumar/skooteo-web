# frozen_string_literal: true

FactoryBot.define do
  factory :play_sequence_video do
    segment { 0 }
    segment_order { 0 }
    segment_type { 'RegularSpot' }
  end
end
