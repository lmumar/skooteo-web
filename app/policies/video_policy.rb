# frozen_string_literal: true

class VideoPolicy < ApplicationPolicy
  def auto_approve?
    user.role.fleet_operator_admin? && record.announcement?
  end

  def update?
    fleet_personnel?
  end

  def destroy?
    (!record.approved? || record.playlists.empty?)
  end

  def fleet_personnel?
    [user.role.fleet_operator_admin?, user.role.fleet_operator?].any?
  end
end
