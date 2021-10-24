# frozen_string_literal: true

class Credit < ApplicationRecord
  include HasFinder

  belongs_to :campaign, optional: true
  belongs_to :company, touch: true
  belongs_to :recorder, class_name: 'User', foreign_key: 'recorder_id'

  validates :transaction_code, presence: true
  validates_numericality_of :amount

  scope :order_recent, -> { order(id: :desc) }
  scope :with_running_balance, -> {
    select('credits.*, (select sum(a.amount) from credits a where a.id <= credits.id and credits.company_id = a.company_id) as running_balance').order(id: :desc)
  }
end
