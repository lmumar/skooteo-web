# frozen_string_literal: true

module ActiveStorageHelpers
  def create_file_blob(filename: "sample.mp4", content_type: "video/mp4", metadata: nil)
    ActiveStorage::Blob.create_and_upload! io: file_fixture(filename).open, filename: filename, content_type: content_type, metadata: metadata
  end
end

RSpec.configure do |config|
  config.include ActiveStorageHelpers
end
