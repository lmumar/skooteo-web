class AddOffOnBoardingFieldsToVehicleRoutes < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicle_routes, :time_allotted_for_onboarding_in_minutes, :float, default: 0
    add_column :vehicle_routes, :time_allotted_for_offboarding_in_minutes, :float, default: 0
  end
end
