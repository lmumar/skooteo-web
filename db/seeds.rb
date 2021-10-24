# frozen_string_literal: true

Video.all.each(&:destroy)

[
  Addon,
  Company,
  CompanyAddon,
  Role,
  User,
  UserRole,
  Person
].each do |model|
  ActiveRecord::Base.connection.execute(<<-SQL
    TRUNCATE #{model.table_name} RESTART IDENTITY;
  SQL
  )
end

skooteo = Company.new(name: 'Skooteo', company_type: 0, time_zone: 'Australia/Sydney')
skooteo.skip_event_tracking = true
skooteo.save!

Role.create!(Skooteo::ROLES)

admin = User.create!(
  email: 'admin@skooteo.com',
  password: "#{ENV['ADMIN_PASSWORD']}",
  password_confirmation: "#{ENV['ADMIN_PASSWORD']}",
  company: Company.skooteo.first
)

Person.create!(
  user: admin,
  first_name: 'Skooteo',
  last_name: 'Admin'
)

UserRole.create!(
  user: admin,
  role: Role.find_by!(code: 'admin'),
  grantor: admin
)

Addon.create!(
  code: 'advertising',
  creator: admin,
  description: 'Allow advertisers to buy spots from your fleet'
)

Addon.create!(
  code: 'media',
  creator: admin,
  description: 'Allow media addon'
)
