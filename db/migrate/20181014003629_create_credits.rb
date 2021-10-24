class CreateCredits < ActiveRecord::Migration[5.2]
  def change
    create_table :credits do |t|
      t.belongs_to :company
      t.string :transaction_code, null: false
      t.decimal :amount, precision: 12, scale: 2
      t.string :particulars
      t.integer :recorder_id
      t.timestamps
    end
    add_index :credits, [:company_id, :transaction_code]
    add_index :credits, [:recorder_id]
  end
end
