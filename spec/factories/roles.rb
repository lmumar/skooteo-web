FactoryBot.define do
  factory :role do
  end

  factory :admin_role, class: Role do
    name { 'Admin' }
    code { 'admin' }
  end

  factory :advertiser_role, class: Role do
    name { 'Advertiser' }
    code { 'advertiser' }
  end

  factory :fleet_operator_role, class: Role do
    name { 'Fleet Operator' }
    code { 'fleet_operator' }
  end

  factory :fleet_operator_admin_role, class: Role do
    name { 'Fleet operator admin' }
    code { 'fleet_operator_admin' }
  end
end
