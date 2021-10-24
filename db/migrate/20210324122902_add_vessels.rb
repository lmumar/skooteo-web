# frozen_string_literal: true

class AddVessels < ActiveRecord::Migration[6.1]
  def change
    create_table :vessels do |t|
      t.integer :kind, null: false, index: true
      t.timestamps
    end
  end
end
