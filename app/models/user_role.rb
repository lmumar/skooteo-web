class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
  belongs_to :grantor, class_name: 'User', foreign_key: 'grantor_id'
end
