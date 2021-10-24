class CreateCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns do |t|
      t.belongs_to :company
      t.string :name, null: false
      t.integer :advertiser_id
      t.date :start_date, :end_date
      t.timestamps
    end
  end
end
