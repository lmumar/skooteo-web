# frozen_string_literal: true

class CreateCompanyAddons < ActiveRecord::Migration[6.1]
  def change
    create_table :company_addons do |t|
      t.belongs_to :company
      t.belongs_to :addon
      t.integer :creator_id, index: true, null: false
      t.timestamps
      t.index [:company_id, :addon_id], unique: true
    end
  end
end
