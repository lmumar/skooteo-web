# frozen_string_literal: true

module Authenticate
  extend ActiveSupport::Concern

  included do
    include ByCookie, ByDeviceToken

    before_action :authenticate
  end

  protected
    def signed_in?
      !Current.user.nil?
    end

    def sign_out
      cookies.encrypted[:user_id] = nil
    end

  private
    def authenticate
      if authenticate_with_cookie? || authenticate_with_device_token?
        ## were in!!!
      else
        request_cookie_authentication
      end
    end
end
