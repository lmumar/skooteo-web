# frozen_string_literal: true

module RoleRequirements
  def require_admin!
    forbidden unless current_user.role&.admin?
  end

  def require_advertiser!
    forbidden unless current_user.role&.advertiser?
  end

  def require_content_provider!
    forbidden unless Current.company.content_provider?
  end

  def require_fleet_operator!
    forbidden unless [current_user.role&.fleet_operator?, current_user.role&.fleet_operator_admin?].any?
  end

  def require_skooteo_personnel!
    forbidden unless current_user.company&.skooteo?
  end
end
