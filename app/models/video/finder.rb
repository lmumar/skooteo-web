# frozen_string_literal: true

class Video::Finder
  include SearchObject.module(:will_paginate, :sorting)

  per_page 100

  scope {
    Video.includes(:company, :creator).with_attached_content
  }

  option(:status)     { |scope, status| scope.where status: status }
  option(:company)    { |scope, company| scope.where company_id: company.id }
  option(:company_type) { |scope, type| scope.where companies: { company_type: type } }
  option(:creator)    { |scope, creator| scope.where creator_id: creator.id }
  option(:video_type) { |scope, video_type|
    video_type.present? ? scope.where(video_type: video_type) : scope
  }
  option(:non_demo)    { |scope, value| scope.where(companies: { demo: !value }) }
  option(:non_skooteo) { |scope, value|
    value ?
      scope.where.not(companies: { company_type: Company.company_types[:skooteo] }) :
      scope.where(companies: { company_type: Company.company_types[:skooteo] })
  }
  option(:demo_or_skooteo) { |scope, value|
    value ?
      scope.where(companies: { demo: true }).or(
        scope.where(companies: { company_type: Company.company_types[:skooteo] })
      ) :
      scope.where(companies: { demo: false }).where.not(companies: { company_type: Company.company_types[:skooteo] })
  }

  sort_by :updated_at
end
