class SessionsController < ApplicationController
  skip_before_action :authenticate

  def create
    user = User.find_by email: user_params[:email]
    if user && authenticated_user = user.authenticate(user_params[:password])
      authenticated_user.touch :last_signin_at
      Current.user = authenticated_user
      cookies.encrypted[:user_id] = authenticated_user.id
      cookies[:role] = Current.user.role&.code
      redirect_to determine_root_path
      return
    end
    flash[:error] = 'Invalid username/password'
    redirect_to new_session_path
  end

  def destroy
    cookies.encrypted[:user_id] = nil
    session.clear
    redirect_to new_session_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def determine_root_path
    if Current.user.role&.admin?
      admin_companies_path(company_type: 'fleet_operator')
    elsif Current.user.role&.advertiser?
      media_spots_path
    elsif [Current.user.role&.fleet_operator?, Current.user.role&.fleet_operator_admin?].any?
      fleet_vessels_path
    elsif Current&.company&.content_provider?
      content_provider_videos_path
    else
      Rails.logger.error { "Invalid user role #{Current.user.role&.code}" }
      raise Skooteo::NotPermittedError
    end
  end
end
