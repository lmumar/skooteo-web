# frozen_string_literal: true

class Playlist
  class Sequencing
    attr_reader :timeslot

    def initialize(timeslot, selection = Selection.new, segmenting = Segmenting.new)
      @timeslot = timeslot
      @selection = selection
      @segmenting = segmenting
    end

    def call
      return nil unless timeslot

      advertiser_videos = collect_videos(timeslot)
      return nil unless advertiser_videos.present?

      generate_trip_playlist(advertiser_videos)
    end

    private
      def collect_videos(timeslot)
        sorted_advertisers = advertisers_sorted_by_spot_bookings(timeslot)

        sorted_advertisers.each_with_object(Hash.new { |hsh, k| hsh[k] = [] }) do |advertiser, hsh|
          spots_with_playlist = advertiser.spots.where(time_slot_id: timeslot.id).reject { |spot| spot.playlist.nil? }
          vids = spots_with_playlist.each_with_object(Hash.new { |h, k| h[k] = [] }) { |spot, hash|
            hash[spot.type] += spot.playlist.playlist_videos.order(:play_order).map { |pv| SpotVideo.new(pv, spot) }
          }

          Spot.types.all.each do |spot_type|
            vvids = vids[spot_type].select { |video| video.duration_in_seconds > 0 }
            campaign_videos = vvids.group_by { |video| video.spot.campaign_id }
            ad_spots = vvids.map(&:spot).uniq
            campaign_spots = ad_spots.group_by(&:campaign_id)
            campaign_spots.each do |(campaign_id, spots)|
              spot_count  = spots.sum(&:count)
              spot_videos = campaign_videos[campaign_id] || []
              next if spot_videos.empty? || spot_count.zero?
              hsh[spot_type] << @selection.call(spot_videos, spot_count)
            end
          end
        end
      end

      def generate_trip_playlist(advertiser_videos)
        playlist = {
          time_slot_id: timeslot.id,
          video_ids: Set.new,
          premium: {
            sequence: [],
            segment_duration_in_minutes: timeslot.vehicle_route.premium_ads_segment_duration.in_minutes,
          },
          regular: {
            sequence: [],
            segment_duration_in_minutes: timeslot.vehicle_route.regular_ads_segment_duration.in_minutes,
          },
        }

        Spot.types.all.each do |spot_type|
          next if advertiser_videos[spot_type].flatten.compact.empty?
          segments =
            if spot_type == Spot.types.premium
              temp = @segmenting.call(
                advertiser_videos[spot_type],
                @timeslot.vehicle_route.premium_ads_segment_count,
              )
              [temp.flatten]
            else
              @segmenting.call(
                advertiser_videos[spot_type],
                @timeslot.vehicle_route.regular_ads_segment_count
              )
            end

          segments.each_with_index do |segment, i|
            segment.each_with_index do |pv, j|
              playlist[:video_ids].add(pv.video.id)
              sequences = playlist.dig(spot_type.to_sym, :sequence)
              sequences[i] ||= []
              sequences[i] << pv.video.id
            end
          end
        end

        playlist
      end

      def advertisers_sorted_by_spot_bookings(timeslot)
        timeslot.spots.group_by(&:company)
          .sort_by { |_, spots| spots.sum(&:count) }
          .reverse
          .map { |l| l.first }
      end
  end
end
