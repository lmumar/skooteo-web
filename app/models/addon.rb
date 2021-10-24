# frozen_string_literal: true

class Addon < ApplicationRecord
  include Const
  include HasCreator

  has_many :companies

  validates :code, presence: true

  const available: %w[advertising media]
end
