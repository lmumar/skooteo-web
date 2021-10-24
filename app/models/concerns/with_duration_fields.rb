# frozen_string_literal: true

module WithDurationFields
  extend ActiveSupport::Concern

  class_methods do
    def to_duration_field(*args, **kwargs)
      mappings = kwargs.to_a + args
      mappings.each do |mapping|
        self.new.class.class_eval do
          field_name, duration_field_name = mapping
          composed_of duration_field_name,
            class_name: 'ActiveSupport::Duration',
            mapping: [ field_name, 'value' ],
            constructor: Proc.new { |field| ActiveSupport::Duration.build(field) },
            converter: Proc.new { |value| ActiveSupport::Duration.build(value.is_a?(String) ? value.to_i : value) }
        end
      end
    end
  end
end
