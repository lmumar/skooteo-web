# frozen_string_literal: true

FactoryBot.define do
  factory :video do
    name { generate(:video_name) }
    status { Video.statuses[:approved] }
    video_type { 'advertisement' }

    trait :with_attachment do
      transient do
        attachment_file_name { 'sample.mp4' }
        attachment_content_type { 'video/mp4' }
        attachment_metadata { { 'duration' => 70 } }
      end

      after(:create) do |video, evaluator|
        attachment = ActiveStorage::Blob.create_after_upload!(
          io: file_fixture(evaluator.attachment_file_name).open,
          filename: evaluator.attachment_file_name,
          content_type: evaluator.attachment_content_type,
          metadata: evaluator.attachment_metadata
        )
        video.content.attach(attachment)
      end
    end
  end
end
