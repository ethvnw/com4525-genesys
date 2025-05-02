# frozen_string_literal: true

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
  description: "Create and share a timeline of your trip, showing events, activities, and bookings with friends.",
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: trip_timeline,
  subscription_tier: free_tier,
)

ticket_booking_uploads = AppFeature.find_or_create_by!(
  name: "Ticket & Booking Uploads",
  description: "Upload and store your tickets, bookings, and receipts in one place, easy to access.",
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: ticket_booking_uploads,
  subscription_tier: free_tier,
)

collaborative_planning = AppFeature.find_or_create_by!(
  name: "Collaborative Planning",
  description: "Plan together by tagging friends on bookings and activities for a smoother trip.",
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: collaborative_planning,
  subscription_tier: free_tier,
)

travel_budget_expenses = AppFeature.find_or_create_by!(
  name: "Travel Budget & Expenses",
  description: "Log expenses and track your budget for stress-free travel.",
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: travel_budget_expenses,
  subscription_tier: free_tier,
)

trip_sharing_privacy = AppFeature.find_or_create_by!(
  name: "Trip Sharing & Privacy Control",
  description: "Share trip plans with others and control who can see the details.",
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: trip_sharing_privacy,
  subscription_tier: free_tier,
)

travel_reminders_notifications = AppFeature.find_or_create_by!(
  name: "Travel Reminders & Notifications",
  description: "Get reminders and alerts for flights, bookings, and activities.",
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: travel_reminders_notifications,
  subscription_tier: free_tier,
)

flight_tickets = AppFeature.find_or_create_by!(
  name: "Flight Tickets",
  description: "Store and manage your flight tickets with details like departure, destination, and times.",
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: flight_tickets,
  subscription_tier: free_tier,
)

hotel_accommodation = AppFeature.find_or_create_by!(
  name: "Hotel Bookings",
  description: "Manage hotels and accomodation bookings, all accessible during your trip.",
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: hotel_accommodation,
  subscription_tier: free_tier,
)

car_hire_transportation = AppFeature.find_or_create_by!(
  name: "Car Hire Bookings",
  description: "Keep all your transport details, like car hire bookings, in one place.",
)
AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: car_hire_transportation,
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
