# frozen_string_literal: true

module ContentProvider
  class BaseController < ApplicationController
    before_action :require_content_provider!
  end
end
