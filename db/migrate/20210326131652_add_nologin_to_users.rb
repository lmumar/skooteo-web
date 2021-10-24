# frozen_string_literal: true

class AddNologinToUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.boolean :no_login, default: false, index: true
    end
  end
end
