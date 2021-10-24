# frozen_string_literal: true

class AddFcmNotificationTokenToVehicles < ActiveRecord::Migration[6.1]
  def change
    add_column :vehicles, :fcm_notification_token, :string
  end
end
