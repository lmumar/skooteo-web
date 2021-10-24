# frozen_string_literal: true

module Media
  class CampaignsController < BaseController
    before_action :set_campaigns, only: %w(index)
    before_action :set_selected_campaigns, only: %w(show)

    def index
      respond_to do |format|
        format.html
        format.json
      end
    end

    def set_playlist
      Current.company.transaction do
        if params[:regular_playlist_id].present?
          Spot.regular.where(id: params[:spot_ids]).each { |spot|
            spot.update(playlist_id: params[:regular_playlist_id])
            Spot::TriggerVesselNotifyNewVideoJob.perform_later spot
          }
        end

        if params[:premium_playlist_id].present?
          Spot.premium.where(id: params[:spot_ids]).each { |spot|
            spot.update(playlist_id: params[:premium_playlist_id])
            Spot::TriggerVesselNotifyNewVideoJob.perform_later spot
          }
        end
      end

      set_selected_campaigns
    end

    private
      def set_campaigns
        start_date = 3.months.ago((params[:start_date]&.to_date || Date.today).beginning_of_month)
        end_date   = 12.months.since(start_date)
        @campaign_search = CampaignSearch.new filters: { start_date: start_date, end_date: end_date, company: Current.company }
      end

      def set_selected_campaigns
        if params[:spot_ids]
          spot_ids = params.fetch(:spot_ids)
          @spots   = Spot
            .includes([:campaign, :route, { vehicle_route_schedule: :vehicle }])
            .where(id: spot_ids)
          @campaigns = @spots.map(&:campaign).uniq
          @campaign_summary = CampaignSummary.new @campaigns, @spots
        else
          @campaigns = Current.company
            .campaigns
            .includes(spots: [{ vehicle_route_schedule: :vehicle }, :route])
            .where(id: params[:id])
          @campaign_summary = CampaignSummary.new @campaigns
        end
      end
  end
end
