module UserServices
  class Registration
    attr_reader :user
    attr_reader :user_params

    def initialize user_params
      @user_params = user_params
    end

    def call
      User.transaction do
        @user = User.create! user_params
      end
      @user
    end
  end

  class Updates
    attr_reader :user
    attr_reader :user_params

    def initialize user, user_params
      @user = user
      @user_params = user_params
    end

    def call
      user.transaction do
        user.attributes = user_params
        user.save!
      end
    end
  end

  class PasswordReset
    attr_reader :user

    def initialize user, old_password, new_password
      @user = user
      @old_password = old_password
      @new_password = new_password
    end

    def call
      raise 'Empty password' unless @new_password.present?
      user.transaction do
        auth_user = user.authenticate(@old_password)
        if auth_user
          auth_user.password = @new_password
          auth_user.password_confirmation = @new_password
          auth_user.save!
        else
          raise 'Invalid password'
        end
      end
    rescue => e
      raise Skooteo::PasswordResetFailed, e.message
    end
  end
end
