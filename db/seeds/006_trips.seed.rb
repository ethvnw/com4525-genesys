# frozen_string_literal: true

require_relative "seed_helpers"

brienz_trip = Trip.find_or_create_by!(
  title: "Switzerland Summer '25",
  description: "Hiking and stuff",
  location_name: "Brienz, Switzerland",
  location_latitude: 46.7560001,
  location_longitude: 8.0303006,
  start_date: Time.zone.parse("2025-06-17 00:00:00"),
  end_date: Time.zone.parse("2025-06-22 23:59:59"),
  created_at: Time.zone.parse("2025-04-21 17:34:00"),
  updated_at: Time.zone.parse("2025-04-21 17:34:00"),
)

seed_trip_image(brienz_trip, "brienz.png")

beach_weekend = Trip.find_or_create_by!(
  title: "Beach Weekend Getaway",
  description: "Quick weekend escape to the coast",
  location_name: "Brighton, United Kingdom",
  location_latitude: 50.8214626,
  location_longitude: -0.1400561,
  start_date: Time.zone.parse("2025-06-21 00:00:00"),
  end_date: Time.zone.parse("2025-06-22 23:59:59"),
  created_at: Time.zone.parse("2025-03-28 20:17:00"),
  updated_at: Time.zone.parse("2025-03-28 20:17:00"),
)

seed_trip_image(beach_weekend, "brighton.jpg")

graduation = Trip.find_or_create_by!(
  title: "Graduation!",
  description: "Uni? Completed it mate",
  location_name: "Sheffield, United Kingdom",
  location_latitude: 53.3806626,
  location_longitude: -1.4702278,
  start_date: Time.zone.parse("2025-07-24 00:00:00"),
  end_date: Time.zone.parse("2025-07-26 23:59:59"),
  created_at: Time.zone.parse("2025-04-27 12:23:00"),
  updated_at: Time.zone.parse("2025-04-27 12:23:00"),
)

seed_trip_image(graduation, "sheffield.jpg")

australia = Trip.find_or_create_by!(
  title: "Australian Adventure",
  description: "Getting away from the winter",
  location_name: "Australia",
  location_latitude: -25.1635022,
  location_longitude: 136.755022,
  start_date: Time.zone.parse("2025-12-01 00:00:00"),
  end_date: Time.zone.parse("2025-12-22 23:59:59"),
  created_at: Time.zone.parse("2025-04-22 11:05:00"),
  updated_at: Time.zone.parse("2025-04-22 11:05:00"),
)

seed_trip_image(australia, "australia.jpg")

interrailing = Trip.find_or_create_by!(
  title: "Summer Interrailing",
  description: "Interrailing through Germany, Austria, and Czechia.",
  location_name: "Europe",
  location_latitude: 51,
  location_longitude: 10,
  start_date: Time.zone.parse("2026-08-01 00:00:00"),
  end_date: Time.zone.parse("2026-08-15 23:59:59"),
  created_at: Time.zone.parse("2025-04-15 18:30:00"),
  updated_at: Time.zone.parse("2025-04-15 18:30:00"),
)

seed_trip_image(interrailing, "europe.jpg")
