#!/usr/bin/env ruby
# frozen_string_literal: true

require "database_cleaner"

##
# Generates a random new location from a given centre
# @param centre [Array<Double>] the centre of the random distribution
# @return a new set of coordinates with a random latitude/longitude offset from centre
def get_random_location(centre)
  prng = Random.new
  lat_offset = prng.rand(-50...50)
  lng_offset = prng.rand(-50...50)

  [centre[0] + lat_offset, centre[1] + lng_offset]
end

##
# Creates a single trip (if that one does not already exist)
#
# @param user [User] the user to create the trip for
# @param trip_number [Integer] the trip number
# @param trip_title [String] the title of the trip
# @return [Trip] the newly-created trip
def create_trip(user, trip_number, trip_title = "Trip #{trip_number}")
  preexisting_trip = Trip.where(title: trip_title).first
  first_trip = Trip.where(title: "Trip 1").first
  unless preexisting_trip.present?
    trip_coords = get_random_location([0, 0])
    trip = Trip.create!(
      title: trip_title,
      description: "Trip Description #{trip_number}",
      start_date: Time.current + (2 * trip_number).days,
      end_date: Time.current + (2 * trip_number + 1).days,
      location_latitude: trip_coords[0],
      location_longitude: trip_coords[1],
      location_name: "Sheffield",
    )

    # Use one blob for all trips for performance
    image_blob = first_trip&.image&.blob

    if image_blob.present?
      trip.image.attach(image_blob)
    else
      trip.image.attach(
        # attach fallback_location_img.png in packs/images
        io: File.open(Rails.root.join("db", "seeds", "images", "trips", "brienz.jpg")),
        filename: "brienz.jpg",
        content_type: "image/jpeg",
      )
    end

    TripMembership.create!(
      sender_user: user,
      is_invite_accepted: true,
      invite_accepted_date: trip.created_at,
      user: user,
      trip: trip,
    )
  end

  preexisting_trip || trip
end

##
# Creates or retrieves a user from the database
#
# @param user_number [Integer] the number of the user
# @return [User] the created/found user model
def create_user(user_number)
  preexisting_user = User.where(username: "user#{user_number}").first
  unless preexisting_user.present?
    user = User.new(
      username: "user#{user_number}",
      email: "test#{user_number}@example.com",
      password: "tester",
      password_confirmation: "tester",
    )

    user.save(validate: false)
  end

  preexisting_user || user
end

VALID_MODELS = [:trip, :plan, :invite, :user, :referral]
unless VALID_MODELS.include?(ARGV.first.to_sym)
  puts "Usage: db-flooder [#{VALID_MODELS.map(&:to_s).join(" | ")}]"
  exit 1
end

Rails.application.eager_load!

if ENV["clean_first"].present?
  DatabaseCleaner.clean_with(:truncation)
  puts ">>>> Database cleaned.\n\n"
end

User.new(
  username: "tester",
  email: "tester@example.com",
  password: "tester",
  password_confirmation: "tester",
).save(validate: false) unless User.where(username: "tester").first.present?
user = User.find_by(username: "tester")

puts ">>>> Created test user with username: '#{user.username}' and password: 'tester'\n\n"

model = ARGV.first.to_sym
amount = (ARGV[1] || 1000).to_i

puts ">>>> Flooding database with #{model}s..."

case model
when :trip
  amount.times do |i|
    create_trip(user, i)
    print("#{(i + 1).to_s.rjust(4, "0")}/#{amount}\r")
  end

  puts(">>>> Added #{amount} trips to user '#{user.username}'")
when :invite
  second_user = create_user(0)
  amount.times do |i|
    trip = create_trip(second_user, i, "Second User Trip #{i}")
    TripMembership.create!(
      sender_user: second_user,
      is_invite_accepted: false,
      user: user,
      trip: trip,
    )
    print("#{(i + 1).to_s.rjust(4, "0")}/#{amount}\r")
  end

  puts(">>>> Added #{amount} trip invites from user '#{second_user.username}' to user '#{user.username}'")
when :plan
  trip = create_trip(user, 1)

  amount.times do |i|
    plan_location = get_random_location([trip.location_latitude, trip.location_longitude])
    Plan.new(
      trip_id: trip.id,
      title: "Plan #{i}",
      plan_type: Plan.plan_types[:active],
      start_location_name: "Augstmatthorn, Oberreid am Brienzersee, Switzerland",
      start_location_latitude: plan_location[0],
      start_location_longitude: plan_location[1],
      start_date: trip.start_date + (2 * i).minutes,
      end_date: trip.start_date + (2 * i + 1).minutes,
    ).save(validate: false) unless Plan.where(title: "Plan #{i}").present?
    print("#{(i + 1).to_s.rjust(4, "0")}/#{amount}\r")
  end

  puts(">>>> Added #{amount} plans to trip '#{trip.title}'")
when :user
  amount.times do |i|
    create_user(i)
    print("#{(i + 1).to_s.rjust(4, "0")}/#{amount}\r")
  end

  puts(">>>> Added #{amount} users to DB")
when :referral
  amount.times do |i|
    user = create_user(i)
    Referral.create!(
      sender_user: user,
      receiver_email: "referral#{i}@example.com",
    )
    print("#{(i + 1).to_s.rjust(4, "0")}/#{amount}\r")
  end

  puts(">>>> Added #{amount} referrals to DB")
end
