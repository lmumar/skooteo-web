# frozen_string_literal: true

class MetricDistanceType < ActiveRecord::Type::Value
  def cast(value)
    return value if value.is_a?(MetricDistance)
    # value should be expressed in meters
    # ''.to_f and nil.to_f results to 0.0
    deserialize(value.to_f)
  end

  def deserialize(value)
    MetricDistance.new(value.to_f)
  end

  def serialize(value)
    value.value
  end
end
