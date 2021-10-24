# frozen_string_literal: true

module HasFinder
  extend ActiveSupport::Concern

  class_methods do
    def search(filters = {})
      # access the class that mixes this module and
      # use the Finder class specific to the mixer class.
      self.new.class::Finder.new(filters)
    end

    def results(filters = {})
      # access the class that mixes this module and
      # use the Finder class specific to the mixer class.
      self.new.class::Finder.results(filters)
    end
  end
end
