# frozen_string_literal: true
module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    before_action do
      Current.request_id = request.uuid
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end

    before_action :set_active_storage_host, if: ->{ Rails.env.development? }
  end

  def current_user
    Current.user
  end

  def set_active_storage_host
    ActiveStorage::Current.host = request.base_url
  end
end
