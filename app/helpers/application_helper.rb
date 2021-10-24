# frozen_string_literal: true

module ApplicationHelper
  def current_credits
    @credits ||= Current.company.credits.sum(&:amount)
  end

  def active_css(watch)
    watch == controller_name ? 'is-active' : nil
  end

  def active_css_iftrue(&block)
    yield ? 'is-active' : nil
  end

  def format_currency(amount)
    number_to_currency amount, unit: ''
  end

  def format_number(n)
    number_with_delimiter n
  end

  def fleet_operator_options
    FleetOperatorSearch.all.map { |company| [company.name, company.id] }
  end

  def role_options
    Role.order(:name).map { |role| [role.name, role.id] }
  end

  def vehicle_status_options
    Vehicle.statuses.keys.map do |code|
      [t("vehicle_statuses.#{code}"), code]
    end
  end
end
