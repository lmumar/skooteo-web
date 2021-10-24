# frozen_string_literal: true

module VesselSchedulesHelper
  def options_for_wday
    Date::DAYNAMES.map.with_index { |wday, i| [wday, i] }
  end

  def options_for_schedule_type
    VehicleRouteSchedule::SCHEDULE_TYPES
  end

  def options_for_schedule_statuses
    options = ['active', 'inactive']
    options_for_select(options, params[:inactive] == '1' ? options[1] : options[0])
  end
end
