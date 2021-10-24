# frozen_string_literal: true

class AddTimezoneToCompanies < ActiveRecord::Migration[6.1]
  def change
    change_table :companies do |t|
      t.string :time_zone
    end
  end
end
