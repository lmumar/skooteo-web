# frozen_string_literal: true

class Vessel::Finder
  include SearchObject.module :sorting

  scope {
    Vessel
      .includes(vehicle: :image_attachment)
      .order(created_at: :desc)
  }

  option(:company) { |scope, company| scope.where vehicles: { company_id: company.id } }

  option(:name) do |scope, query|
    where_string = "vehicles.name ILIKE '%<query>s'" % [query: "%#{query}%"]
    (where_string.present? && scope.where(where_string)) || scope
  end

  option(:route_id) { |scope, route_id|
    route_id.present? ? scope.includes(vehicle: :routes).where(routes: { id: route_id }) : scope
  }

  option(:status) { |scope, status|
    status.present? ? scope.where(vehicles: { status: status }) : scope
  }

  option(:capacity) { |scope, capacity|
    capacity.present? ? scope.where(vehicles: { capacity: capacity }) : scope
  }
end
