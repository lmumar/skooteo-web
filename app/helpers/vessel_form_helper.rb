# frozen_string_literal: true

module VesselFormHelper
  def capacities_options
    Current
      .company
      .vessels
      .map(&:capacity)
      .uniq
      .sort
  end

  def vessel_names_options
    Current
      .company
      .vessels
      .map(&:name)
      .uniq
      .sort
  end

  def vessel_next_schedule(vessel_id)
    schedules = @vessel_schedules_index[vessel_id] || []
    now = Time.zone.now
    schedules.detect { |schedule|
      dt = ('%s %s' % [schedule.trip_date, schedule.etd.strftime('%H:%M:%S')])
      dt = Time.zone.parse(dt)
      dt >= now
    }
  end

  def format_vessel_schedule(vehicle_route_schedule)
    return '' unless vehicle_route_schedule
    dt = vehicle_route_schedule.trip_date
    tm = vehicle_route_schedule.etd.strftime('%I:%M %p')
    '%s %s' % [dt, tm]
  end

  def vessel_route_schedule_destination(vehicle_route_schedule)
    return '' unless vehicle_route_schedule
    vessel_route = @vessel_routes_index[vehicle_route_schedule.vehicle_route_id]
    vessel_route&.route&.destination || ''
  end

  def vessel_route_schedule_origin(vehicle_route_schedule)
    return '' unless vehicle_route_schedule
    vessel_route = @vessel_routes_index[vehicle_route_schedule.vehicle_route_id]
    vessel_route&.route&.origin || ''
  end

  def vessel_routes_options
    Current
      .company
      .routes
      .map { |r| [r.name, r.id] }
      .sort_by { |r| r[0] }
  end

  def vessel_kind_select(form, field_name = :kind)
    form.select field_name, vessel_kinds, {}
  end

  def vessel_kinds
    Vessel.kinds.to_a.map { |(code, _value)| [code.humanize, code] }
  end

  def vessel_active_admin_tab
    case controller_name
    when 'vessel_routes'
      1
    when 'vessel_media_settings'
      2
    when 'vessel_route_schedules'
      3
    else
      -1
    end
  end
end
