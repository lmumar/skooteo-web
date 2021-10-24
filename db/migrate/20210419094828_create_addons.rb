# frozen_string_literal: true

class CreateAddons < ActiveRecord::Migration[6.1]
  def change
    create_table :addons do |t|
      t.string :code, null: false
      t.string :description
      t.integer :creator_id, index: true
      t.timestamps
      t.index :code, unique: true
    end
  end
end
