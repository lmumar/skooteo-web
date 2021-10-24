# frozen_string_literal: true

FactoryBot.define do
  factory :video_play_log do
    video
    play_start { Time.now }
    video_type { 'entertainment' }
  end
end
