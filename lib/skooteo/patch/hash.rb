# frozen_string_literal: true

module Skooteo
  module Patch
    module ExtendedHash
      refine Hash do
        def to_duration
          data = slice(:hh, :mm, :ss)

          hh = data.fetch(:hh, '0').to_i.hours
          mm = data.fetch(:mm, '0').to_i.minutes
          ss = data.fetch(:ss, '0').to_i.seconds

          hh + mm + ss
        end
      end
    end
  end
end
