# frozen_string_literal: true
class DashboardPolicy < Struct.new(:user, :dashboard)
  def index?
    !user.role&.passenger?
  end
end
