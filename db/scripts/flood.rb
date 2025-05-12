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
# @return [Trip] the newly-created trip
def create_trip(user, trip_number)
  preexisting_trip = Trip.where(title: "Trip #{trip_number}").first
  unless preexisting_trip.present?
    trip_coords = get_random_location([0, 0])
    trip = Trip.create!(
      title: "Trip #{trip_number}",
      description: "Trip Description #{trip_number}",
      start_date: Time.current + (2 * trip_number).days,
      end_date: Time.current + (2 * trip_number + 1).days,
      location_latitude: trip_coords[0],
      location_longitude: trip_coords[1],
      location_name: "Sheffield",
    )

    trip.image.attach(
      # attach fallback_location_img.png in packs/images
      io: File.open(Rails.root.join("db", "seeds", "images", "trips", "brienz.jpg")),
      filename: "brienz#{i}.jpg",
      content_type: "image/jpeg",
    )

    TripMembership.create!(
      sender_user: user,
      # Accept invite if flooding with trips, don't accept if flooding with invitations
      is_invite_accepted: model == :trip,
      invite_accepted_date: trip.created_at,
      user: user,
      trip: trip,
    )
  end

  preexisting_trip || trip
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

puts ">>>> Flooding database with #{model}s..."

case model
when :trip, :invite
  1000.times do |i|
    create_trip(user, i)
    print("#{(i + 1).to_s.rjust(4, "0")}/1000\r")
  end
when :plan
  trip = create_trip(user, 1)

  1000.times do |i|
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
    print("#{(i + 1).to_s.rjust(4, "0")}/1000\r")
  end

  puts(">>>> Added 1000 plans to trip '#{trip.title}'")
when :user
  1000.times do |i|
    User.new(
      username: "user#{i}",
      email: "test#{i}@example.com",
      password: "tester",
      password_confirmation: "tester",
    ).save(validate: false) unless User.where(username: "user#{i}").first.present?
    print("#{(i + 1).to_s.rjust(4, "0")}/1000\r")
  end

  puts(">>>> Added 1000 users to DB")
end
