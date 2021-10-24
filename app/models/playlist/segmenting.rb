# frozen_string_literal: true

class Playlist
  class Segmenting
    def call(playlists, segments_count)
      nplaylists  = normalize_playlist_lens_base_on_max(playlists)
      dplaylists  = distribute(nplaylists)
      total_spots = playlists.flatten.compact.sum(&:consumable_spot_count)
      soft_limit  = (total_spots / (segments_count * 1.0)).round
      segments    = segments_count.times.inject([]) { |segs, _| segs << [] }

      i = 0
      dplaylists.each do |video|
        segment = segments[i]
        spots_consumed = segment.sum(&:consumable_spot_count)
        if spots_consumed >= soft_limit
          i = (i + 1 < segments.length) ? i + 1 : i
          segment = segments[i]
        end
        segment << video
      end

      segments
    end

    # ensure that playlist lengths are the same, for smaller
    # playlist fill the missing place with nil
    def normalize_playlist_lens_base_on_max(playlists)
      limit = playlists.map(&:length).max
      playlists.each do |playlist|
        next if playlist.size == limit
        (limit - playlist.size).times.each { playlist.push(nil) }
      end
      playlists
    end

    def distribute(playlists)
      playlists.transpose.flatten.compact
    end
  end
end
