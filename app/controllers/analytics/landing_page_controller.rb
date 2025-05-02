# frozen_string_literal: true

module Analytics
  # Landing page analytics controller
  class LandingPageController < Analytics::BaseController
    def index
      # Statistics for registrations
      @registrations_today = Registration.count_today
      @registrations_this_week = Registration.count_this_week
      @registrations_this_month = Registration.count_this_month
      @registrations_all_time = Registration.count
      @registrations_by_country = Registration.count_by_country

      # Statistics for landing page visits
      @landing_page_visits_today = LandingPageVisit.count_today
      @landing_page_visits_this_week = LandingPageVisit.count_this_week
      @landing_page_visits_this_month = LandingPageVisit.count_this_month
      @landing_page_visits_all_time = LandingPageVisit.count
      @landing_page_visits_by_country = LandingPageVisit.count_by_country

      # Statistics for feature sharing - Free tier is the only features on the landing page
      @app_features_engagement = AppFeature.engagement_stats(:Free)

      # Statistics for subscription tiers
      @subscription_tiers_engagement = SubscriptionTier.engagement_stats
    end
  end
end
