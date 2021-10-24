class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :companies, :name, opclass: :gin_trgm_ops, using: :gin
  end
end
