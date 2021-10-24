# frozen_string_literal: true
module Authorize
  extend ActiveSupport::Concern

  include Pundit

  def authorize(*)
    super
  rescue Pundit::NotAuthorizedError
    raise Skooteo::NotPermittedError
  end
end
