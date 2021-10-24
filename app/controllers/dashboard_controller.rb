# frozen_string_literal: true
class DashboardController < ApplicationController
  def index
    authorize :dashboard, :index?
  end
end
