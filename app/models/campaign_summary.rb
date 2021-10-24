# frozen_string_literal: true

class CampaignSummary
  attr_reader :campaigns

  def initialize(campaigns, spots = nil)
    @campaigns = campaigns
    @spots     = spots
  end

  def bookings
    @bookings ||= get_bookings
  end

  def total_regular_spots
    bookings.sum(&:regular)
  end

  def total_premium_spots
    bookings.sum(&:premium)
  end

  def spots
    @spots ||= @campaigns.map(&:spots).flatten
  end

  def playlists
    @playlist ||= (
      regular, premium = self.spots.partition(&:regular?)
      Hash.new.tap do |hash|
        hash[:regular] = regular.map(&:playlist).compact.uniq
        hash[:premium] = premium.map(&:playlist).compact.uniq
      end
    )
  end

  def playlists_videos(spot_type)
    self.playlists[spot_type].map(&:playlist_videos).flatten
  end

  private
    def get_bookings
      grouping = self.spots.group_by(&:vehicle_route_schedule)
      grouping.keys.sort { |sked1, sked2| sked1.etd <=> sked2.etd }.each_with_object([]) do |schedule, list|
        spots = grouping[schedule]
        parts = spots.partition(&:regular?)
        list << OpenStruct.new.tap do |booking|
          booking.trip_date = schedule.etd.to_date
          booking.route     = schedule.route.name
          booking.vessel    = schedule.vehicle.name
          booking.etd       = schedule.etd
          booking.eta       = schedule.eta
          booking.regular   = parts[0].sum(&:count)
          booking.premium   = parts[1].sum(&:count)
          booking.capacity  = schedule.vehicle.capacity
        end
      end
    end
end
