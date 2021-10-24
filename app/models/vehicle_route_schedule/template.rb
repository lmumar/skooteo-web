# frozen_string_literal: true

class VehicleRouteSchedule::Template
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :effective_start_date, :effective_end_date,
    :days, :td, :tt_hr, :tt_min

  validates :effective_start_date, :days, :td, :tt_hr, :tt_min, presence: true

  def create_schedules!(vehicle_route)
    schedules(vehicle_route) do |etd, eta|
      VehicleRouteSchedule.create!(
        route: vehicle_route.route,
        vehicle_route: vehicle_route,
        etd: etd,
        eta: eta
      )
    rescue => e
      Rails.logger.error { "[!] " + e.message }
    end
  end

  # generates a pair of dates [time_of_departure, time_of_arrival]
  def schedules(vehicle_route, &block)
    return unless block_given?
    dates do |date|
      ztd = Time.zone.parse(td)
      etd = Time.zone.parse("#{date.strftime("%F")} #{ztd.strftime("%T")}")
      eta = etd + vehicle_route.estimated_travel_duration.in_seconds
      block.call etd, eta
    end
  end

  private
    def dates(&block)
      start_date = Time.zone.parse(effective_start_date).to_date
      end_date = Time.zone.parse(effective_end_date).to_date
      (start_date..end_date).each do |date|
        next unless days.has_key?(date.wday.to_s)
        block.call date
      end
    end
end
