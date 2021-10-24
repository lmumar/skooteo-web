class AddLastSigninAt < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_signin_at, :datetime
  end
end
