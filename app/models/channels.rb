# frozen_string_literal: true
class Channels
  attr_reader :company

  def initialize(company)
    @company = company
  end

  def total_videos(channel)
    playlist = channels[channel]
    playlist&.videos&.count || 0
  end

  def total_runtime_in_seconds(channel)
    playlist = channels[channel]
    (playlist&.videos || []).reduce(0) { |acc, vid| acc += vid.duration_in_seconds }
  end

  def channels
    @channels ||= begin
      playlists = @company.playlists.includes(:videos).where(channel: Skooteo::VIDEO_CHANNELS)
      playlists.index_by(&:channel)
    end
  end

  def channels_sorted
    @channels_sorted ||= channels.values.flatten.sort { |a, b| a.name <=> b.name }
  end
end
