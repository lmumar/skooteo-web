# frozen_string_literal: true

namespace :migrations do
  desc 'Skooteo | Update predefined roles'
  task 'roles:update_roles' => :environment do
    Current.user = User.find_by!(email: 'admin@skooteo.com')
    Skooteo::ROLES.each do |attr|
      role = Role.find_or_initialize_by(code: attr[:code])
      role.name = attr[:name]
      role.save!
    end
  end
end
