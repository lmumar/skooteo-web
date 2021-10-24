class AddFleetOperatorAdminRole < ActiveRecord::Migration[5.2]
  def change
    Role.create!(
      name: 'Fleet Operator Admin',
      code: 'fleet_operator_admin'
    )
  end
end
