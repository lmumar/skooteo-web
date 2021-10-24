# frozen_string_literal: true

class Vessel < ApplicationRecord
  include HasFinder
  include Vehicleable

  enum kind: %i[ passenger_fast_craft roro_fast_craft small_passenger_ferry
    large_passenger_ferry roro waterbus ]
end
