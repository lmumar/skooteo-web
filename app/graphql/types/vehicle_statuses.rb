module Types
  class VehicleStatuses < Types::BaseEnum
    value "PRE_DEPLOYMENT", "Pre Deployment", value: "pre_deployment"
    value "ACTIVE_SERVICE", "Active Service", value: "active_service"
    value "UNDER_MAINTENANCE", "Under Maintenance", value: "under_maintenance"
    value "DECOMMISSIONED", "Decommissioned", value: "decommissioned"
  end
end
