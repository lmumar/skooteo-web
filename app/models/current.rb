# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :user, :person, :company, :vehicle
  attribute :request_id, :user_agent, :ip_address

  resets { Time.zone = nil }

  def user=(user)
    super
    return unless user
    self.person = user.person
    self.company = user.company
    Time.zone = user.company.time_zone
  end
end
