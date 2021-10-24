# frozen_string_literal: true

class AssignPlaylistChannelsToFleetOps < ActiveRecord::Migration[5.2]
  def change
    creator = User.find_by_email('admin@skooteo.com')
    channel = 'general'
    return unless creator

    Company.fleet_operator.each do |company|
      next if company.playlists.where(channel: channel).count > 0
      playlist = company.playlists.build(
        name: channel.humanize,
        channel: channel,
        creator: creator,
        status: Playlist.statuses[:active]
      )
      playlist.skip_event_tracking = true
      playlist.save!
    end
  end
end
