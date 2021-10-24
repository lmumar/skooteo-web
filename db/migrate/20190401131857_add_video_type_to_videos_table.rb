class AddVideoTypeToVideosTable < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :video_type, :string
    add_index :videos, :video_type

    Video.find_in_batches do |batch|
      batch.each do |video|
        video.video_type = video.company.advertiser? ? Skooteo::ADS_VIDEO_TYPE :
          Skooteo::ANNOUNCEMENT_VIDEO_TYPE
        video.skip_event_tracking = true
        video.save!
      end
    end
  end
end
