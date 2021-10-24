# frozen_string_literal: true

module CompanyOwnable
  extend ActiveSupport::Concern
  included do
    belongs_to :company, default: -> { Current.user.company }
  end
end
