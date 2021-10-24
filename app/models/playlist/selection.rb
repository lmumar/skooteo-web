# frozen_string_literal: true

class Playlist
  class Selection
    def call(videos, total_spots)
      spot_videos = []
      spot_count  = total_spots

      done = false
      i = 0
      j = 0

      while !done
        v  = videos[i % videos.size]
        i += 1

        spot_consumed = v.consumable_spot_count
        if spot_consumed > spot_count
          done = j >= videos.size
          j += 1
          next
        end

        spot_count -= spot_consumed
        spot_videos << v
        j = 0
        done = spot_count.zero?
      end

      spot_videos
    end
  end
end
