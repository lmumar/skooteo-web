# frozen_string_literal: true

class VehicleRouteSchedule::Finder
  include SearchObject.module(:sorting)

  scope {
    VehicleRouteSchedule.unscoped.includes(:creator)
  }

  option(:company_ids) { |scope, ids|
    scope.includes(:company).where companies: { id: ids }
  }

  option(:destination) { |scope, destination|
    scope.includes(:route).where('LOWER(routes.destination) = ?', [destination&.downcase])
  }

  option(:inactive) { |scope, value|
    value == '1' ? scope.inactive : scope.active
  }

  option(:origin) { |scope, origin|
    scope.includes(:route).where('LOWER(routes.origin) = ?', [origin&.downcase])
  }

  option(:route) { |scope, route|
    route ? scope.where(route: route) : scope
  }

  option(:route_ids) { |scope, route_ids|
    route_ids.present? ? scope.where(route_id: route_ids) : scope
  }

  option(:vehicle_id) { |scope, id|
    scope.includes(:vehicle).where(vehicles: { id: id })
  }

  option(:vehicle_route) { |scope, vehicle_route|
    scope.where(vehicle_route: vehicle_route)
  }

  option(:period) do |scope, period|
    mmyy = [period[:yyyy], period[:mm], '01'].join('-')
    start_date = Date.parse(mmyy)
    stop_date = start_date.end_of_month
    scope.where('etd between ? and ?', start_date, stop_date)
  end

  option(:etd_between) do |scope, dates|
    dt1 = dates[:date1]
    dt2 = dates[:date2]
    scope.where('etd between ? and ?', dt1, dt2)
  end

  sort_by :etd
end
