# frozen_string_literal: true

module WithInitials
  extend ActiveSupport::Concern

  def initials(limit: 3)
    fail('Make sure class has name attribute') unless self.respond_to?(:name)

    return '' unless name.present?

    name
      .split(/\s/)
      .select { |part| part =~ /^[a-zA-Z]/ }[0...limit]
      .compact
      .map { |part| part[0] }
      .join
  end
end
