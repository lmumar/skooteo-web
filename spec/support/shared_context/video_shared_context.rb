# frozen_string_literal: true

RSpec.shared_context 'video' do
  def create_video_config(creator, duration = 6, status = 1)
    config = OpenStruct.new
    config.creator  = creator
    config.duration = duration
    config.status   = status
    config
  end

  def create_videos(video_configs)
    Array.wrap(video_configs).map.with_index do |config, i|
      video = create(
        :video,
        status: config.status,
        company: config.creator.company,
        creator: config.creator
      )
      attachment = create_file_blob(
        filename: "sample.mp4",
        content_type: "video/mp4",
        metadata: { 'duration' => config.duration }
      )
      video.content.attach(attachment)
      video
    end
  end
end
