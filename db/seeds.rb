# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# db/seeds.rb
if ENV["clear_first"]
  DatabaseCleaner.clean_with(:truncation)
end

trip = Trip.find_or_create_by!(
  title: "Trip to Paris",
  description: "A trip to Paris, France.",
  start_date: Time.zone.now + 1.day,
  end_date: Time.zone.now + 5.days,
  location_name: "Paris, France",
  location_latitude: 48.8566,
  location_longitude: 2.3522,
)

# Attach the local image if not already attached
unless trip.image.attached?
  trip.image.attach(
    io: File.open(Rails.root.join("db", "seed_images", "paris.jpg")),
    filename: "paris.jpg",
    content_type: "image/jpeg",
  )
end

User.create!(
  email: "admin@genesys.com",
  username: "admin1",
  password: "AdminGenesys#1",
  password_confirmation: "AdminGenesys#1",
  user_role: User.user_roles[:admin],
  invitation_accepted_at: Time.zone.now,
) unless User.exists?(email: "admin@genesys.com")

TripMembership.create!(
  trip_id: Trip.find_by(title: "Trip to Paris").id,
  user_id: User.find_by(email: "admin@genesys.com").id,
  sender_user_id: User.find_by(email: "admin@genesys.com").id,
  is_invite_accepted: true,
  invite_accepted_date: Time.zone.now,
  user_display_name: "admin1",
) unless TripMembership.exists?(
  trip_id: Trip.find_by(title: "Trip to Paris").id,
  user_id: User.find_by(email: "admin@genesys.com").id,
  sender_user_id: User.find_by(email: "admin@genesys.com").id,
)

User.create!(
  email: "reporter@genesys.com",
  username: "reporter1",
  password: "ReporterGenesys#1",
  password_confirmation: "ReporterGenesys#1",
  user_role: User.user_roles[:reporter],
  invitation_accepted_at: Time.zone.now,
) unless User.exists?(email: "reporter@genesys.com")

Question.create!(
  question: "How do I upload tickets and bookings to the app?",
  answer: "You can upload tickets and booking through either barcode scanning or manual entry.",
  is_hidden: false,
  engagement_counter: 0,
  order: 1,
) unless Question.exists?(question: "How do I upload tickets and bookings to the app?")

Question.create!(
  question: "Can I organise group trips with friends or family?",
  answer: "Yes! Roamio supports both solo and group trips.",
  is_hidden: false,
  engagement_counter: 0,
  order: 2,
) unless Question.exists?(question: "Can I organise group trips with friends or family?")

Review.create!(
  name: "Jack Burke",
  content: "Roamio will make travel planning stress-free! All my tickets,
itineraries, and travel ideas in one place!",
  order: 1,
  is_hidden: false,
) unless Review.exists?(name: "Jack Burke")

Review.create!(
  name: "Jack Sanders",
  content: "Roamio's trip timeline will help me to make sure I never forget
about a plan! Amazing!",
  order: 2,
  is_hidden: false,
) unless Review.exists?(name: "Jack Sanders")

Review.create!(
  name: "James March",
  content: "I can't wait to get reminders about my flights and plans. No more
missed flights for me!",
  order: 3,
  is_hidden: false,
) unless Review.exists?(name: "James March")

Review.create!(
  name: "Kush Bharakhada",
  content: "Roamio will let me finally share my itineraries with my friends!
No more disagreements over plans!",
  order: 4,
  is_hidden: false,
) unless Review.exists?(name: "Kush Bharakhada")

Review.create!(
  name: "Ethan Watts",
  content: "Roamio brings all your travel essentials into one place! I can't
wait to keep track of my car hire bookings on here!",
  order: 5,
  is_hidden: false,
) unless Review.exists?(name: "Ethan Watts")

Review.create!(
  name: "Ellis Barker",
  content: "Roamio is my dream app! I can finally stop worrying about losing my
tickets by uploading them here!",
  order: 6,
  is_hidden: false,
) unless Review.exists?(name: "Ellis Barker")

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

# Find coords using Bboxfinder [http://bboxfinder.com]
locations = [
  { name: "Sheffield",     country_code_iso: "GB", latitude: 53.376871, longitude: -1.500425 },
  { name: "London",        country_code_iso: "GB", latitude: 51.604225, longitude: -0.066248 },
  { name: "Birmingham",    country_code_iso: "GB", latitude: 52.4862, longitude: -1.8904 },
  { name: "Crawley Down",  country_code_iso: "GB", latitude: 51.120869, longitude: -0.077256 },
  { name: "Leicester",     country_code_iso: "GB", latitude: 52.6369, longitude: -1.1398 },
  { name: "East Grinstead", country_code_iso: "GB", latitude: 51.124004, longitude: -0.006735 },
  { name: "Singapore",     country_code_iso: "SG", latitude: 1.340698, longitude: 103.837444 },
  { name: "New York",      country_code_iso: "US", latitude: 40.7128, longitude: -74.0060 },
  { name: "Paris",         country_code_iso: "FR", latitude: 48.8566, longitude: 2.3522 },
]

locations.each do |location|
  featured = FeaturedLocation.find_or_create_by!(
    name: location[:name],
    country_code_iso: location[:country_code_iso],
    latitude: location[:latitude],
    longitude: location[:longitude],
  )

  next if featured.image.attached?

  # Convert name to snake case format, e.g. "new_york"
  file_name = location[:name].parameterize.underscore
  image_path = Rails.root.join("db", "seed_images", "featured_locations", "#{file_name}.png")

  featured.image.attach(
    io: File.open(image_path),
    filename: "#{file_name}.png",
    content_type: "image/png",
  )
end
