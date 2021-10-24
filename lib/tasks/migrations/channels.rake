# frozen_string_literal: true

namespace :migrations do
  desc 'Skooteo | Update predefined fleet channels'
  task 'channels:update_fleet_channels' => :environment do
    Current.user = User.find_by!(email: 'admin@skooteo.com')
    Company.fleet_operator.each do |fleet_operator|
      Skooteo::VIDEO_CHANNELS.each do |channel|
        playlist = fleet_operator.playlists.find_or_initialize_by(channel: channel)
        if playlist.new_record?
          playlist.name = channel.humanize
          playlist.creator = Current.user
          playlist.status = Playlist.statuses[:active]
          playlist.save!
        end
      end
    end
  end
end
