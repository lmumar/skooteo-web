# frozen_string_literal: true

class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name, :code, null: false
      t.timestamps
    end
    add_index :roles, :code, unique: true
    add_index :roles, :name, opclass: :gin_trgm_ops, using: :gin
  end
end
