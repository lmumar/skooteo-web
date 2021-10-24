# frozen_string_literal: true

module Authenticate::ByDeviceToken
  def authenticate_with_device_token?
    @authenticate_via_device_token = false
    device_token = http_auth_header
    return false if device_token.nil?
    vehicle = Vehicle.find_by_device_token(device_token)
    if vehicle
      Current.user = vehicle.company.system_account
      Current.user.touch(:last_signin_at)
      Current.vehicle = vehicle
      @authenticate_via_device_token = true
      return true
    end
    false
  end

  def http_auth_header
    if request.headers['Authorization'].present?
      return request.headers['Authorization'].split(' ').last
    end
    nil
  end

  def performed_device_token_auth?
    @authenticate_via_device_token
  end
end
