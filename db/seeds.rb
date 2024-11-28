# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# db/seeds.rb

User.create!(
  email: "admin@genesys.com",
  password: "AdminGenesys#1",
  password_confirmation: "AdminGenesys#1",
  user_role: :admin,
) unless User.exists?(email: "admin@genesys.com")

User.create!(
  email: "reporter@genesys.com",
  password: "ReporterGenesys#1",
  password_confirmation: "ReporterGenesys#1",
  user_role: :reporter,
) unless User.exists?(email: "reporter@genesys.com")

Question.create!(
  question: "How do I upload tickets and bookings to the app?",
  answer: "You can upload tickets and booking through either barcode scanning or manual entry.",
  is_hidden: false,
  engagement_counter: 0,
) unless Question.exists?(question: "How do I upload tickets and bookings to the app?")

Question.create!(
  question: "Can I organise group trips with friends or family?",
  answer: "Yes! Roamio supports both solo and group trips.",
  is_hidden: false,
  engagement_counter: 0,
) unless Question.exists?(question: "Can I organise group trips with friends or family?")

free_tier = SubscriptionTier.find_or_create_by!(
  name: "Free",
  price_gbp: 0.0,
  discount_description: nil,
  terms_description: nil,
)

SubscriptionTier.find_or_create_by!(
  name: "Individual",
  price_gbp: 2.99,
  discount_description: "Free for 1 month",
  terms_description: "1 user only",
)

SubscriptionTier.find_or_create_by!(
  name: "Group",
  price_gbp: 5.99,
  discount_description: nil,
  terms_description: "Groups of up to 6 people",
)

trip_timeline = AppFeature.find_or_create_by!(
  name: "Trip Timeline",
  description: "Create and share a timeline of your trip, featuring key events, activities, 
   and bookings, all in one place with your friends.",
)

AppFeaturesSubscriptionTier.find_or_create_by!(
  app_feature: trip_timeline,
  subscription_tier: free_tier,
)
