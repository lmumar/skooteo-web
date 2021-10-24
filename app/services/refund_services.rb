module RefundServices
  module_function

  def process_refunds
    TripLog.processed.find_in_batches do |trip_logs|
      trip_logs.each(&method(:process_trip_log))
    end
  end

  SEGMENT_SPOT_TYPE_MAPPINGS = {
    'regular' => 'RegularSpot',
    'premium' => 'PremiumSpot'
  }
  def process_trip_log(trip_log)
    segments = trip_log.trip_info['segments'] || { }
    return if segments.empty?

    company_refundables = Hash.new { |hsh, key| hsh[key] = 0 }
    SEGMENT_SPOT_TYPE_MAPPINGS.keys.each do |segment_type|
      played_video_ids = normalize_video_ids(segments[segment_type] || [], segment_type)
      refundable_video_ids = get_refundable_video_ids(played_video_ids, segment_type, trip_log)
      next if refundable_video_ids.empty?
      compute_refundable(
        trip_log,
        refundable_video_ids,
        Skooteo::CPMS.fetch(segment_type),
        company_refundables
      )
    end
    recorder = User.find_by!(email: 'admin@skooteo.com')
    trip_log.transaction do
      company_refundables.each do |company, refundable|
        company.credits.system_refund!(nil, refundable, recorder)
      end
      trip_log.settled!
    end
  rescue => e
    trip_log.status_details = "error: #{e.message}, previous_status: #{trip_log.status}"
    trip_log.error!
  end

  def normalize_video_ids(video_ids, segment_type)
    segment_type == 'premium' ? [video_ids] : video_ids
  end

  # get_refundable_video_ids find all the unplayed video ids since
  # they need to be refunded.
  #
  # segment_video_ids is an array of array of video ids which are taken
  # from the trip_log.trip_info attributes
  # e.g. [[nil, nil, 1, 2], [1, 2, nil, nil]]
  # segment_tpe - can be regular | premium
  # trip_log
  def get_refundable_video_ids(segment_video_ids, segment_type, trip_log)
    trip_info      = trip_log.trip_info
    play_sequence  = PlaySequence.find_by!(vehicle_id: trip_info['vessel_id'],
                                          time_slot_id: trip_log.time_slot_id)

    spot_videos = play_sequence
                       .play_sequence_videos
                       .where(segment_type: segment_type)
    return [] if spot_videos.empty?

    sequenced_videos = spot_videos.group_by(&:segment)
    sequenced_video_ids = sequenced_videos.keys.sort.reduce([]) do |lst, i|
      psvs = sequenced_videos[i].sort { |a, b| a.segment_order <=> b.segment_order }
      lst << psvs.map(&:video_id)
    end
    refundable_video_ids = []
    segment_video_ids.map.with_index do |video_ids, i|
      sequenced = sequenced_video_ids[i] || []
      diff = sequenced - video_ids
      refundable_video_ids += diff
    end
    refundable_video_ids
  end

  def compute_refundable(trip_log, refundable_video_ids, cpm, company_refundables)
    raise NotImplementedError, 'todo'
    # refundable_videos = Video.where(id: refundable_video_ids)
    # refundable_index  = refundable_videos.index_by(&:id)
    # refundable_video_ids.each do |video_id|
    #   video = refundable_index[video_id]
    #   next unless video
    #   refundable = SpotBookingServices.compute_booking_cost(
    #     video.consumable_spot_count,
    #     cpm,
    #     trip_log.time_slot.vehicle.passenger_capacity
    #   )
    #   company_refundables[video.company] += refundable
    # end
  end
end
