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
  lng_offset = prng.rand(-25...25)

  [centre[0] + lat_offset, centre[1] + lng_offset]
end

VALID_MODELS = [:trip, :plan, :invite, :user, :referral]
unless VALID_MODELS.include?(ARGV.first.to_sym)
  puts "Usage: db-flooder [#{VALID_MODELS.map(&:to_s).join(" | ")}]"
  exit 1
end

Rails.application.eager_load!
DatabaseCleaner.clean_with(:truncation)
puts ">>>> Database cleaned.\n\n"

User.new(
  username: "tester",
  email: "tester@example.com",
  password: "tester",
  password_confirmation: "tester",
).save(validate: false)
user = User.find(1)

puts ">>>> Created test user with username: '#{user.username}' and password: 'tester'\n\n"

model = ARGV.first.to_sym

case model
when :trip, :invite
  puts ">>>> Flooding database with #{model}s..."
  1000.times do |i|
    trip_coords = get_random_location([53.376859, -1.500393])
    trip = Trip.create!(
      title: "Trip #{i}",
      description: "Trip Description #{i}",
      start_date: Time.current + (2 * i).days,
      end_date: Time.current + (2 * i + 1).days,
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
      user: user,
      trip: trip,
    )
    print("#{(i + 1).to_s.rjust(4, "0")}/1000\r")
  end
end
