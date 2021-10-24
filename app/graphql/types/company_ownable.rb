# frozen_string_literal: true

module Types
  module CompanyOwnable
    include BaseInterface

    description "Types that are associated to a company"

    field :company, Types::CompanyType, null: false

    def company
      RecordLoader.for(Company).load(object.company_id)
    end
  end
end
