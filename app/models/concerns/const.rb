# frozen_string_literal: true

module Const
  extend ActiveSupport::Concern

  class_methods do
    def const(definitions)
      klass = self
      definitions.each do |name, values|
        if values.is_a?(Array)
          vvals = values.map { |value| [value.to_sym, value] }
          attrs = Hash[vvals].merge(all: values)
        else
          attrs = values.merge(all: values.values)
        end
        konst = OpenStruct.new(attrs)
        klass.class_attribute(name.to_sym, instance_writer: false, default: konst)
      end
    end
  end
end
