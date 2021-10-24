# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionView::RecordIdentifier

  include Authenticate
  include SetCurrentRequestDetails
  include Authorize
  include RoleRequirements

  protected
    def forbidden
      handle_error 403
    end

    def not_found
      handle_error 404
    end

    def unprocessable_entity
      handle_error 422
    end

    def handle_error(code)
      respond_to do |format|
        format.any { head code }
      end
    end
end
