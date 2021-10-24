# frozen_string_literal: true

class User < ApplicationRecord
  include Confirmable
  include HasFinder

  has_many :videos, foreign_key: :creator_id

  has_one :person, inverse_of: :user
  has_one :user_role, inverse_of: :user
  has_one :role, through: :user_role

  has_secure_password

  belongs_to :company, touch: true, optional: true

  accepts_nested_attributes_for :person, :user_role

  validates :email, presence: true, uniqueness: true

  delegate :full_name, to: :person

  def self.create_nologin_account(company)
    company.users.create(
      email: "#{company.id}@system.skooteo.com",
      password: SecureRandom.hex(12),
      no_login: true
    )
  end
end
