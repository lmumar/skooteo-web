class AddCampaignIdToCreditsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :credits, :campaign_id, :integer
    add_index :credits, :campaign_id
  end
end
