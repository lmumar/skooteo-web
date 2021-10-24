# frozen_string_literal: true

module Media
  class SpotsController < BaseController
    before_action :set_date_range, only: %w(new create calculate)
    before_action :set_spot_booking_from_route_schedules, only: %w(new)
    before_action :set_spot_booking_from_params, only: %w(create calculate)

    def create
      @spot_booking.book
    end

    def calculate
    end

    private
      def set_date_range
        @start_date = Time.zone.parse(params[:start_date])
        @end_date   = @start_date.end_of_day
      end

      def set_spot_booking_from_route_schedules
        route_schedules = VehicleRouteSchedule.results(filters: {
          etd_between: { date1: @start_date, date2: @end_date },
          route_ids: params[:route_ids],
          sort: 'etd'
        })
        booking_items = route_schedules.map { |record|
          Spot::BookingItem.from(vehicle_route_schedule: record)
        }
        @spot_booking = Spot::Booking.new(campaign_name: '', items: booking_items)
      end

      def set_spot_booking_from_params
        interval = nil
        ndays    = nil

        if params['x_repeat'].present?
          interval = params['xdays_options'] == 'Days' ? 1 : 7
          ndays    = params['x_repeat'].to_i
        end

        @spot_booking = Spot::Booking.reset(
          spots_params[:campaign_name],
          spots_params[:items],
          repeat: ndays,
          day_intervals: interval
        )
      end

      def spots_params
        params.require(:spot_booking).permit(
          :campaign_name,
          items: [
            { item: Spot::BookingItem::VALID_ATTRIBUTE_KEYS }
          ]
        )
      end
  end
end
