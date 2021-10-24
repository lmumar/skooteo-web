# frozen_string_literal: true

module CompaniesHelper
  def company_type_options
    [['Select', '']] + Skooteo::COMPANY_TYPES.map { |attr| [attr[:name], attr[:code]] }
  end

  def fleet_operator_options
    Company.results(filters: { with_addons: Addon.available.advertising }).map { |company| [company.name, company.id] }
  end

  def set_company_type_tab_class(matches)
    matches == params[:company_type] ? "is-active" : nil
  end

  def transaction_code_options
    [['Select', ''], ['Credits Added', 'credits_added'], ['Refund', 'credit_refund']]
  end
end
