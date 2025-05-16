# frozen_string_literal: true

require_relative "seed_helpers"

free_tier = SubscriptionTier.find_or_create_by!(
  name: "Free",
  price_gbp: 0.0,
  discount_description: nil,
  terms_description: nil,
)

individual_tier = SubscriptionTier.find_or_create_by!(
  name: "Individual",
  price_gbp: 2.99,
  discount_description: "Free for 1 month",
  terms_description: "1 user only.",
)

group_tier = SubscriptionTier.find_or_create_by!(
  name: "Group",
  price_gbp: 5.99,
  discount_description: nil,
  terms_description: "Groups of up to 6 people. Explorer features only available on group trips you create.",
)

trip_timeline = AppFeature.find_or_create_by!(
  name: "Trip Timeline",
  description: "Create and share a timeline of your trip, showing events, activities, and bookings with friends",
)
seed_app_feature_image(trip_timeline, "trip_timeline.webp")
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: trip_timeline,
  subscription_tier: free_tier,
)

ticket_booking_uploads = AppFeature.find_or_create_by!(
  name: "Ticket & Booking Uploads",
  description: "Upload and store your tickets, bookings, and receipts in one place, easy to access",
)
seed_app_feature_image(ticket_booking_uploads, "trip_tickets.webp")
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: ticket_booking_uploads,
  subscription_tier: free_tier,
)

collaborative_planning = AppFeature.find_or_create_by!(
  name: "Collaborative Planning",
  description: "Plan together with friends and family on bookings and activities for a smoother trip",
)
seed_app_feature_image(collaborative_planning, "collaborative_planning.webp")
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: collaborative_planning,
  subscription_tier: free_tier,
)

view_trips = AppFeature.find_or_create_by!(
  name: "View All Your Trips",
  description: "Access and view all your personal and shared trips in one place",
)
seed_app_feature_image(view_trips, "view_trips.webp")
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: view_trips,
  subscription_tier: free_tier,
)

view_trips_map = AppFeature.find_or_create_by!(
  name: "See Your Trips on a Map",
  description: "Check out all your trips laid out on a map to get the full picture",
)
seed_app_feature_image(view_trips_map, "view_trips_map.webp")
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: view_trips_map,
  subscription_tier: free_tier,
)

export_itinerary_pdf = AppFeature.find_or_create_by!(
  name: "Export Your Itinerary to PDF",
  description: "Easily save and share your trip plans by exporting your itinerary as a handy PDF",
)
seed_app_feature_image(export_itinerary_pdf, "export_plans.webp")
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: export_itinerary_pdf,
  subscription_tier: free_tier,
)

view_plans_map = AppFeature.find_or_create_by!(
  name: "View Plans on Map",
  description: "See all your trip plans laid out clearly on a map",
)
seed_app_feature_image(view_plans_map, "view_plans_map.webp")
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: view_plans_map,
  subscription_tier: free_tier,
)

no_ads = AppFeature.find_or_create_by!(
  name: "No Ads",
  description: nil,
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: no_ads,
  subscription_tier: individual_tier,
)

unlimited_storage = AppFeature.find_or_create_by!(
  name: "Unlimited Storage",
  description: nil,
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: unlimited_storage,
  subscription_tier: individual_tier,
)

trip_insights = AppFeature.find_or_create_by!(
  name: "Trip Insights",
  description: nil,
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: trip_insights,
  subscription_tier: individual_tier,
)

priority_support = AppFeature.find_or_create_by!(
  name: "Priority Support",
  description: nil,
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: priority_support,
  subscription_tier: individual_tier,
)

customisable_notifications = AppFeature.find_or_create_by!(
  name: "Customisable Notifications",
  description: nil,
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: customisable_notifications,
  subscription_tier: individual_tier,
)

live_flight_data = AppFeature.find_or_create_by!(
  name: "Live Flight Data",
  description: nil,
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: live_flight_data,
  subscription_tier: individual_tier,
)

early_access_features = AppFeature.find_or_create_by!(
  name: "Early Access to New Features",
  description: nil,
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: early_access_features,
  subscription_tier: individual_tier,
)

group_trips = AppFeature.find_or_create_by!(
  name: "Group Trips - Up to 6 people on trips you create get access to all Explorer Individual features",
  description: nil,
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: group_trips,
  subscription_tier: group_tier,
)
