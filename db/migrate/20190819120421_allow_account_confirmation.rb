class AllowAccountConfirmation < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string :confirmation_token, default: ''
      t.datetime :confirmation_sent_at
      t.datetime :confirmed_at
      t.index [:email, :confirmation_token]
    end
    now = Time.now
    User.update_all(confirmed_at: now, confirmation_sent_at: now)
  end
end
