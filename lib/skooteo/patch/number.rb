# frozen_string_literal: true

module Skooteo
  module Patch
    module Number
      refine Integer do
        def skstd_round
          self.round(2)
        end
      end

      refine Float do
        def skstd_round
          self.round(2)
        end
      end
    end
  end
end
