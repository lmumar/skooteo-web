# frozen_string_literal: true

module Admin
  class CompaniesController < BaseController
    before_action :set_companies, only: %w(index)
    before_action :set_company, only: %w(edit update)
    before_action :set_credits, only: %w(edit update)

    def new
      @company = Company.new(company_type: params[:company_type])
      set_addon
      respond_to do |format|
        format.html         { redirect_to admin_companies_path(company_type: params[:company_type]) }
        format.turbo_stream { render turbo_stream: turbo_stream.update("modal-container", partial: "edit") }
      end
    end

    def create
      @company = Company.create! company_params
    end

    def edit
      set_addon
    end

    def update
      @company.update!(company_params)
      set_addon
    end

    private
      def company_params
        params.require(:company).permit(:name, :company_type,
          :demo, :time_zone, company_addons_attributes: {})
      end

      def set_credits
        if [ @company.advertiser?, @company.skooteo? ].any?
          @credits = Credit.search(filters: { company: @company })
        end
      end

      def set_company
        @company = Company.find params[:id]
      end

      def set_companies
        @companies = Company.search(
          scope: Company,
          filters: { type: params[:company_type], sort: 'name', query: params[:q] },
          page: params[:page] || 1, per_page: params[:per_page])
      end

      def set_addon
        if params[:company_type] == Company.types.fleet_operator.to_s ||
          @company.company_type == Company.types.fleet_operator.to_s
          Addon.all.each { |addon|
            next if @company.addon_ids.include?(addon.id)
            @company.company_addons.build(addon: addon)
          }
        end
      end
  end
end
