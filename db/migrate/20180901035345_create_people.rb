class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.belongs_to :user
      t.string :first_name, :last_name, null: false
      t.timestamps
    end
  end
end
