class Role < ApplicationRecord
  ROLES = %w(admin advertiser fleet_operator fleet_operator_admin passenger)

  class << self
    ROLES.each do |role|
      define_method "#{role}".to_sym do
        Role.where(code: role).first
      end
    end
  end

  ROLES.each do |role|
    define_method "#{role}?".to_sym do
      self.code == role
    end
  end
end
