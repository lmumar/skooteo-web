# frozen_string_literal: true

module DatetimeHelper
  def format_duration(duration_in_sec)
    return '' if duration_in_sec.nil? || duration_in_sec == 0
    if duration_in_sec > 60
      duration_in_min = duration_in_sec / 60.0
      pluralize(duration_in_min.round, 'min')
    else
      pluralize(duration_in_sec.round, 'sec')
    end
  end

  def format_day_of_week(date)
    I18n.l date, format: :dow
  end

  def format_short_date(date)
    I18n.l date, format: :short
  end

  def format_time(time)
    I18n.l time, format: :ampm
  end

  def format_travel_time(time)
    I18n.l time, format: :tt
  end

  def time_zone_options
    @time_zone_options ||= ActiveSupport::TimeZone::MAPPING.to_a.sort_by(&:first)
  end
end
