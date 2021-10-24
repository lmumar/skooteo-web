class CreateUserRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :user_roles do |t|
      t.belongs_to :user
      t.belongs_to :role
      t.belongs_to :grantor
      t.timestamps
    end
    add_index :user_roles, [:user_id, :role_id]
  end
end
