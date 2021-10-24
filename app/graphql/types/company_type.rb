module Types
  class CompanyType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :company_type, Types::CompanyTypes, null: false
  end
end
