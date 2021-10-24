# frozen_string_literal: true

module Authenticate::ByCookie
  def authenticate_with_cookie?
    user_id = cookies.encrypted[:user_id]
    return false if user_id.nil?
    authenticated_user = User.find_by(id: cookies.encrypted[:user_id])
    return false unless authenticated_user
    Current.user = authenticated_user
    true
  end

  def request_cookie_authentication
    redirect_to new_session_url
  end
end
