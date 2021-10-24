module Users
  class PasswordResetController < ApplicationController
    def create
      begin
        if PasswordResetPolicy.can_reset_password?(Current.user, params)
          service = UserServices::PasswordReset.new(
            Current.user,
            params[:old_password],
            params[:new_password]
          )
          service.call
        else
          raise 'Password reset failed, make sure all fields are filled in and confirmation matches new password.'
        end
        flash[:notice] = 'Password updated!'
      rescue => e
        flash[:error] = e.message
      end
      render :new
    end
  end
end
