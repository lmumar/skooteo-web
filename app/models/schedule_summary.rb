# frozen_string_literal: true
require 'ostruct'

class ScheduleSummary
  attr_reader :schedules

  def initialize schedules
    @schedules = schedules
  end

  def each_route &block
    routes = @schedules.map(&:route).uniq
    sortkey = routes.sort_by(&:name)
    groupings = @schedules.group_by(&:route)
    sortkey.each do |route|
      group  = groupings[route]
      egroup = group.group_by(&:etd)
      cluster = egroup.keys.sort.inject([]) do |list, etd|
        vgroup = egroup[etd].group_by(&:vehicle)
        vgroup.each do |(vehicle, vschedules)|
          wdays = vschedules.map(&:wday).uniq
          schedule = OpenStruct.new
          schedule.route = route
          schedule.date = vschedules[0].effective_start_date
          schedule.etd  = etd
          schedule.eta  = vschedules[0].eta
          schedule.days = days(wdays)
          schedule.vessel = vehicle
          schedule.updated_at = vschedules.sort_by(&:updated_at).last.updated_at
          list << schedule
        end
        list
      end
      yield cluster
    end
  end

  private

  ABBR_DAYNAMES = I18n.t('date.abbr_day_names')
  def days wdays
    diff = (0..6).to_a - wdays
    diff.length.zero? ?
      'Daily' :
      wdays.sort.map { |wday| ABBR_DAYNAMES[wday] }.join(', ')
  end
end
