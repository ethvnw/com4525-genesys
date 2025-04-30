# frozen_string_literal: true

brienz = Trip.find_by(location_name: "Brienz, Switzerland")
brighton = Trip.find_by(location_name: "Brighton, United Kingdom")
Trip.find_by(location_name: "Sheffield, United Kingdom")
Trip.find_by(location_name: "Australia")
Trip.find_by(location_name: "Europe")

Plan.find_or_create_by!(
  trip_id: brienz.id,
  title: "Hardergrat Hike",
  plan_type: Plan.plan_types[:other],
  start_location_name: "Augstmatthorn, Oberreid am Brienzersee, Switzerland",
  start_location_latitude: 46.742241,
  start_location_longitude: 7.92861179,
  start_date: Time.zone.parse("2025-06-19 06:00:00"),
  end_date: Time.zone.parse("2025-06-19 17:00:00"),
  created_at: Time.zone.parse("2025-04-23 17:52:00"),
  updated_at: Time.zone.parse("2025-04-23 17:52:00"),
)

Plan.find_or_create_by!(
  trip_id: brienz.id,
  title: "Brienzer Rothorn Hike",
  plan_type: Plan.plan_types[:other],
  start_location_name: "Brienzer Rothorn, Brienz BE, Switzerland",
  start_location_latitude: 46.787096,
  start_location_longitude: 8.0468683,
  start_date: Time.zone.parse("2025-06-20 11:45:00"),
  end_date: Time.zone.parse("2025-06-20 17:45:00"),
  created_at: Time.zone.parse("2025-04-23 17:55:00"),
  updated_at: Time.zone.parse("2025-04-25 20:34:00"),
)

Plan.find_or_create_by!(
  trip_id: brienz.id,
  title: "Train to Brienzer Rothorn",
  plan_type: Plan.plan_types[:travel_by_train],
  start_location_name: "Brienz BE, Switzerland",
  start_location_latitude: 46.7560001,
  start_location_longitude: 8.0303006,
  end_location_name: "Brienzer Rothorn, Brienz BE, Switzerland",
  end_location_latitude: 46.7873421,
  end_location_longitude: 8.040337,
  start_date: Time.zone.parse("2025-06-20 11:00:00"),
  end_date: Time.zone.parse("2025-06-20 11:30:00"),
  created_at: Time.zone.parse("2025-04-23 17:54:00"),
  updated_at: Time.zone.parse("2025-04-29 09:49:00"),
)

### BRIGHTON
Plan.find_or_create_by!(
  trip_id: brighton.id,
  title: "Train to Brighton",
  plan_type: Plan.plan_types[:travel_by_train],
  start_location_name: "Three Bridges Station, Crawley, United Kingdom",
  start_location_latitude: 51.117998,
  start_location_longitude: -0.161646,
  end_location_name: "Train Station, Brighton, United Kingdom",
  end_location_latitude: 50.8460516,
  end_location_longitude: -0.1547004,
  start_date: Time.zone.parse("2025-06-21 10:00:00"),
  end_date: Time.zone.parse("2025-06-21 10:40:00"),
  created_at: Time.zone.parse("2025-03-29 17:17:00"),
  updated_at: Time.zone.parse("2025-03-29 17:17:00"),
)

Plan.find_or_create_by!(
  trip_id: brighton.id,
  title: "Train to Three Bridges",
  plan_type: Plan.plan_types[:travel_by_train],
  start_location_name: "Train Station, Brighton, United Kingdom",
  start_location_latitude: 50.8460516,
  start_location_longitude: -0.1547004,
  end_location_name: "Three Bridges Station, Crawley, United Kingdom",
  end_location_latitude: 51.117998,
  end_location_longitude: -0.161646,
  start_date: Time.zone.parse("2025-06-22 17:00:00"),
  end_date: Time.zone.parse("2025-06-22 17:40:00"),
  created_at: Time.zone.parse("2025-03-29 17:20:00"),
  updated_at: Time.zone.parse("2025-03-29 17:20:00"),
)
