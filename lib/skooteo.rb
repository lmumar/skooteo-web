# frozen_string_literal: true

module Skooteo
  # Moved to Spot.cpms
  # PREMIUM_CPM = 1.25
  # REGULAR_CPM = 1.0

  COMPANY_TYPES = [
    { name: 'Skooteo', code: 'skooteo' },
    { name: 'Advertiser', code: 'advertiser' },
    { name: 'Content Provider', code: 'content_provider' },
    { name: 'Fleet Operator', code: 'fleet_operator' },
  ]

  # Moved to Spot.cpms
  # CPMS = {
  #   'regular' => Skooteo::REGULAR_CPM,
  #   'premium' => Skooteo::PREMIUM_CPM
  # }

  ROLES = [
    { name: 'Admin', code: 'admin' },
    { name: 'Advertiser', code: 'advertiser' },
    { name: 'Content Provider', code: 'content_provider' },
    { name: 'Fleet Operator', code: 'fleet_operator' },
    { name: 'Fleet Operator Admin', code: 'fleet_operator_admin' },
    { name: 'Passenger', code: 'passenger' }
  ]

  SPOT_VIDEO_DURATION_IN_SEC = 15
  VIDEO_TYPES = [
    ADS_VIDEO_TYPE           = 'advertisement',
    ANNOUNCEMENT_VIDEO_TYPE  = 'announcement',
    ENTERTAINMENT_VIDEO_TYPE = 'entertainment'
  ]
  VIDEO_CHANNELS = [
    GENERAL_VIDEO_CHANNEL   = 'general',
    MOVIES_VIDEO_CHANNEL    = 'movies',
    CONCERT_VIDEO_CHANNEL   = 'concert',
    MUSIC_VID_VIDEO_CHANNEL = 'music_videos'
  ]

  class Error < StandardError; end
  class NotPermittedError < Error; end
  class InsufficentCredits < Error; end
  class InvalidBooking < Error; end
  class PasswordResetFailed < Error; end
  class SequencingInProgress < Error; end
end
