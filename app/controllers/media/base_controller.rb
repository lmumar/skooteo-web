module Media
  class BaseController < ApplicationController
    before_action :require_advertiser!
  end
end
