class AddCompanyType < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :company_type, :integer, after: :name, default: 0
    add_index :companies, :company_type
  end
end
