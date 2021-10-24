module CampaignsHelper
  def campaigns_start_date campaigns
    campaigns.sort { |c1, c2| c1.start_date <=> c2.start_date }.first.start_date
  end

  def campaigns_end_date campaigns
    campaigns.sort { |c1, c2| c1.end_date <=> c2.end_date }.last.end_date
  end
end
