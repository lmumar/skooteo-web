# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Authenticate::ByCookie, Authenticate::ByDeviceToken

    identified_by :current_user

    def connect
      if authenticate_with_cookie? || authenticate_with_device_token?
        self.current_user = Current.user
      else
        reject_unauthorized_connection
      end
    end
  end
end
