# frozen_string_literal: true

module Admin
  module Companies
    class CreditsController < Admin::BaseController
      before_action :set_company
      before_action :set_credits, only: %w(index)

      def index
        respond_to do |format|
          format.js { render "create.js.erb" }
        end
      end

      def create
        @company.credits.create credit_params.merge(recorder: current_user)
        set_credits
      end

      private
        def set_company
          @company ||= Company.find params[:company_id]
        end

        def credit_params
          params.require(:credit)
            .permit(
                  :transaction_code,
                  :amount,
                  :particulars,
                  :price_per_credit
                )
        end

        def set_credits
          @credits = CreditSearch.new(
            filters: { company: @company },
            page: params[:page] || 1, per_page: params[:per_page]
          )
        end
    end
  end
end
