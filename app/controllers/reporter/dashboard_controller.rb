# frozen_string_literal: true

module Reporter
  # Dashboard controller
  class DashboardController < Reporter::BaseController
    def index
      # Statistics for registrations
      @registrations_today = Registration.by_day[Time.current.beginning_of_day] || 0
      @registrations_this_week = Registration.by_week[Time.current.beginning_of_week] || 0
      @registrations_this_month = Registration.by_month[Time.current.beginning_of_month] || 0
      @registrations_all_time = Registration.count
      @registrations_by_country = Registration.by_country

      # Statistics for landing page visits
      @landing_page_visits_today = LandingPageVisit.by_day[Time.current.beginning_of_day] || 0
      @landing_page_visits_this_week = LandingPageVisit.by_week[Time.current.beginning_of_week] || 0
      @landing_page_visits_this_month = LandingPageVisit.by_month[Time.current.beginning_of_month] || 0
      @landing_page_visits_all_time = LandingPageVisit.count
      @landing_page_visits_by_country = LandingPageVisit.by_country

      # Statistics for feature sharing
      @app_features_engagement = AppFeature.get_features_by_tier(:Free)
        &.order(engagement_counter: :desc)
        &.pluck(:name, :engagement_counter) || []

      # Statistics for subscription tiers
      @subscription_tiers_engagement = SubscriptionTier
        &.order(engagement_counter: :desc)
        &.pluck(:name, :engagement_counter) || []
    end
  end
end
