# frozen_string_literal: true

module Reporter
  # Dashboard controller
  class DashboardController < Reporter::BaseController
    def index
      @registrations_today = Registration.by_day[Time.current.beginning_of_day]
      @registrations_this_week = Registration.by_week[Time.current.beginning_of_week]
      @registrations_this_month = Registration.by_month[Time.current.beginning_of_month]
      @registrations_all_time = Registration.count
      @registrations_by_country = Registration.by_country
    end
  end
end
