module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :company, Types::CompanyType, null: false
    field :full_name, String, null: false
  end
end
