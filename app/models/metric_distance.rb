# frozen_string_literal: true

class MetricDistance
  KM_TO_M = 1_000

  def self.from_km(value)
    new(value.to_f * KM_TO_M)
  end

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def km
    @value / KM_TO_M
  end
end
