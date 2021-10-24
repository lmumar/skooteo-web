# frozen_string_literal: true

module Fleet
  class BaseController < ApplicationController
    before_action :require_fleet_operator!
  end
end
