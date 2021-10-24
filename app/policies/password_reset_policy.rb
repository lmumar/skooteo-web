# frozen_string_literal: true
class PasswordResetPolicy < ApplicationPolicy
  class << self
    # _account not used at the moment
    def can_reset_password?(_account, password_attrs)
      [password_attrs[:old_password].present?,
       password_attrs[:new_password].present?,
       password_attrs[:new_password_confirmation].present?].all? &&
       password_attrs[:new_password] == password_attrs[:new_password_confirmation]
    end
  end
end
