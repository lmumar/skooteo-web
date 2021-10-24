# frozen_string_literal: true

class CompanyAddon < ApplicationRecord
  include HasCreator

  belongs_to :company
  belongs_to :addon
end
