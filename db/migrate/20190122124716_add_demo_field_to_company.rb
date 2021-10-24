class AddDemoFieldToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :demo, :boolean, default: false
    add_index :companies, :demo
  end
end
