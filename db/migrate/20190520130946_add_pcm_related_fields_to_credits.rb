class AddPcmRelatedFieldsToCredits < ActiveRecord::Migration[5.2]
  def change
    change_table(:credits) do |t|
      t.decimal :price_per_credit, precision: 12, scale: 2, default: 1
      t.index :created_at
    end
  end
end
