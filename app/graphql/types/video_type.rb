# frozen_string_literal: true

module Types
  class VideoType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :key, String, null: true
    field :url, String, null: false

    def key
      load_content.then { |content| content.key }
    end

    def url
      load_content.then do |content|
        Rails.env.production? ? content.service_url :
          Rails.application.routes.url_helpers.rails_blob_url(content, only_path: false)
      end
    end

    def load_content
      AttachmentLoader.for(:Video, :content).load(object.id)
    end
  end
end
