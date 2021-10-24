# frozen_string_literal: true

class VehicleRouteSchedule < ApplicationRecord
  include Eventable
  include HasCreator
  include HasFinder

  enum status: [ :active, :inactive ]

  belongs_to :vehicle_route
  belongs_to :route

  has_one :time_slot
  has_one :vehicle, through: :vehicle_route
  has_one :company, through: :vehicle

  validates :etd, :eta, presence: true

  validate do |vehicle_route_schedule|
    if vehicle_route_schedule.etd > vehicle_route_schedule.eta
      errors.add(:base, :invalid, message: 'etd should be < eta')
    end
  end

  default_scope { active }

  # select only the schedules from fleet operators that availed
  # the advertising addon
  scope :spot_bookable, -> {
    includes(company: { company_addons: :addon })
      .where(addons: { code: Addon.available.advertising })
  }

  after_create_commit :post_create_setup
  after_update_commit :post_update_setup
  after_destroy_commit do
    trigger_notify_schedule_changes(Vessel::NotifyScheduleChangesJob.notification_types.deleted_schedule)
  end

  private
    def post_create_setup
      autocreate_time_slot if company.addons.enabled?(Addon.available.advertising)
      broadcast_prepend_to 'fleet:schedules', target: 'schedules', partial: 'fleet/vessel_route_schedules/schedule', object: self
      trigger_notify_schedule_changes(Vessel::NotifyScheduleChangesJob.notification_types.new_schedule)
    end

    def autocreate_time_slot
      create_time_slot(
        vehicle: vehicle,
        company: company,
        route: route,
        available_regular_spots: vehicle_route.regular_ads_duration.in_seconds / Spot.video_durations.in_seconds,
        available_premium_spots: vehicle_route.premium_ads_duration.in_seconds / Spot.video_durations.in_seconds
      )
    end

    def trigger_notify_schedule_changes(notification_type)
      Vessel::NotifyScheduleChangesJob.perform_later(vehicle, self.id, notification_type)
    end

    def post_update_setup
      if attribute_previously_changed?(:status)
        if status == 'inactive'
          trigger_notify_schedule_changes(
            Vessel::NotifyScheduleChangesJob.notification_types.cancelled_schedule)
        end
      else
        trigger_notify_schedule_changes(
          Vessel::NotifyScheduleChangesJob.notification_types.updated_schedule)
      end
    end
end
