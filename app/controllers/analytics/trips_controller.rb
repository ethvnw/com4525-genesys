# frozen_string_literal: true

module Analytics
  # Trip analytics controller
  class TripsController < Analytics::BaseController
    include Streamable

    def index
      @trip_counts = {
        today: Trip.count_today,
        this_week: Trip.count_this_week,
        this_month: Trip.count_this_month,
        all_time: Trip.count,
      }

      @plan_counts = {
        today: Plan.count_today,
        this_week: Plan.count_this_week,
        this_month: Plan.count_this_month,
        all_time: Plan.count,
      }

      @invitation_counts = {
        today: TripMembership.count_today,
        this_week: TripMembership.count_this_week,
        this_month: TripMembership.count_this_month,
        all_time: TripMembership.count,
      }

      @pagy, @trips = pagy(Trip.order(:id), limit: 25)
      @trips.decorate

      stream_response("analytics/trips")
    end
  end
end
