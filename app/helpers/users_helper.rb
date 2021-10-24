module UsersHelper
  def company_options selected
    @options ||= (
      company_by_type = companies.group_by(&:company_type)
      grouped_options = company_by_type.keys.inject([]) do |grouping, company_type|
        companies = company_by_type[company_type]
        grouping << [company_type.humanize, companies.map{ |company| [company.name, company.id]}]
      end
      grouped_options_for_select grouped_options, selected
    )
  end

  def companies
    @companies ||= Company.order :name
  end
end
