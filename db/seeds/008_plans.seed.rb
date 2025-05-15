# frozen_string_literal: true

brienz = Trip.find_by(title: "Switzerland Summer '25")
brighton = Trip.find_by(location_name: "Beach Weekend Getaway")
sheffield = Trip.find_by(location_name: "Graduation!")
australia = Trip.find_by(location_name: "Australian Adventure")
europe = Trip.find_by(location_name: "Summer Interrailing")

### BRIENZ
Plan.find_or_create_by!(
  trip_id: brienz.id,
  title: "Hardergrat Hike",
  plan_type: Plan.plan_types[:active],
  start_location_name: "Augstmatthorn, Oberreid am Brienzersee, Switzerland",
  start_location_latitude: 46.742241,
  start_location_longitude: 7.92861179,
  start_date: Time.zone.parse("2025-06-19 06:00:00"),
  end_date: Time.zone.parse("2025-06-19 17:00:00"),
  created_at: Time.zone.parse("2025-04-23 17:52:00"),
)

Plan.find_or_create_by!(
  trip_id: brienz.id,
  title: "Brienzer Rothorn Hike",
  plan_type: Plan.plan_types[:active],
  start_location_name: "Brienzer Rothorn, Brienz BE, Switzerland",
  start_location_latitude: 46.787096,
  start_location_longitude: 8.0468683,
  start_date: Time.zone.parse("2025-06-20 11:45:00"),
  end_date: Time.zone.parse("2025-06-20 17:45:00"),
  created_at: Time.zone.parse("2025-04-23 17:55:00"),
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
)

Plan.find_or_create_by!(
  trip_id: brighton.id,
  title: "Yoga on the beach",
  plan_type: Plan.plan_types[:wellness],
  start_location_name: "Brighton Beach, Brighton, United Kingdom",
  start_location_latitude: 50.8165326,
  start_location_longitude: -0.12306255538831701,
  start_date: Time.zone.parse("2025-06-21 16:00:00"),
  end_date: Time.zone.parse("2025-06-21 18:00:00"),
  created_at: Time.zone.parse("2025-03-30 17:17:00"),
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
)

### SHEFFIELD
Plan.find_or_create_by!(
  trip_id: sheffield.id,
  title: "Graduation Ceremony",
  plan_type: Plan.plan_types[:entertainment],
  start_location_name: "Octagon Centre, Sheffield, United Kingdom",
  start_location_latitude: 53.38063975,
  start_location_longitude: -1.4886054831556885,
  start_date: Time.zone.parse("2025-07-25 12:00:00"),
  end_date: Time.zone.parse("2025-07-25 14:00:00"),
  created_at: Time.zone.parse("2025-04-29 12:54:00"),
)

Plan.find_or_create_by!(
  trip_id: sheffield.id,
  title: "Chill Out",
  plan_type: Plan.plan_types[:free_time],
  start_date: Time.zone.parse("2025-07-25 15:00:00"),
  end_date: Time.zone.parse("2025-07-25 18:00:00"),
  created_at: Time.zone.parse("2025-04-29 13:00:00"),
  updated_at: Time.zone.parse("2025-04-29 13:00:00"),
)

backup = Plan.find_or_create_by!(
  trip_id: sheffield.id,
  title: "Poptarts",
  plan_type: Plan.plan_types[:entertainment],
  start_location_name: "Foundry, Sheffield, United Kingdom",
  start_location_latitude: 53.3807499,
  start_location_longitude: -1.4873464,
  start_date: Time.zone.parse("2025-07-26 00:00:00"),
  end_date: Time.zone.parse("2025-07-26 03:00:00"),
  created_at: Time.zone.parse("2025-04-29 13:33:00"),
  updated_at: Time.zone.parse("2025-04-29 13:33:00"),
)

Plan.find_or_create_by!(
  trip_id: sheffield.id,
  title: "Post-Graduation Shenanigans",
  plan_type: Plan.plan_types[:wellness],
  start_location_name: "West Street Live, Sheffield, United Kingdom",
  start_location_latitude: 53.381055200000006,
  start_location_longitude: -1.476109351672448,
  start_date: Time.zone.parse("2025-07-26 00:00:00"),
  end_date: Time.zone.parse("2025-07-26 03:00:00"),
  created_at: Time.zone.parse("2025-04-29 13:03:00"),
  backup_plan_id: backup.id,
)

### AUSTRALIA
Plan.find_or_create_by!(
  trip_id: australia.id,
  title: "Flight LHR -> SYD",
  plan_type: Plan.plan_types[:travel_by_plane],
  start_location_name: "Heathrow Airport, London, United Kingdom",
  start_location_latitude: 51.46773895,
  start_location_longitude: -0.4587800741571181,
  end_location_name: "Sydney Airport, Sydney, Australia",
  end_location_latitude: -33.946111,
  end_location_longitude: 151.177222,
  start_date: Time.zone.parse("2025-12-01 08:45:00"),
  end_date: Time.zone.parse("2025-12-02 18:50:00"),
  created_at: Time.zone.parse("2025-04-22 13:03:00"),
)

Plan.find_or_create_by!(
  trip_id: australia.id,
  title: "Opera at the Sydney Opera House",
  plan_type: Plan.plan_types[:entertainment],
  start_location_name: "Sydney Opera House, Sydney, Australia",
  start_location_latitude: -33.85719805,
  start_location_longitude: 151.21512338473752,
  start_date: Time.zone.parse("2025-12-14 18:20:00"),
  end_date: Time.zone.parse("2025-12-14 21:00:00"),
  created_at: Time.zone.parse("2025-04-22 13:05:00"),
)

Plan.find_or_create_by!(
  trip_id: australia.id,
  title: "Check out this cool rock I found",
  plan_type: Plan.plan_types[:sightseeing],
  start_location_name: "Uluru, Macdonnell Region, Australia",
  start_location_latitude: -25.344857,
  start_location_longitude: 131.0325171,
  start_date: Time.zone.parse("2025-12-07 11:20:00"),
  end_date: Time.zone.parse("2025-12-14 16:00:00"),
  created_at: Time.zone.parse("2025-04-22 13:05:00"),
)

Plan.find_or_create_by!(
  trip_id: australia.id,
  title: "Flight SYD -> LHR",
  plan_type: Plan.plan_types[:travel_by_plane],
  start_location_name: "Sydney Airport, Sydney, Australia",
  start_location_latitude: -33.946111,
  start_location_longitude: 151.177222,
  end_location_name: "Heathrow Airport, London, United Kingdom",
  end_location_latitude: 51.46773895,
  end_location_longitude: -0.4587800741571181,
  start_date: Time.zone.parse("2025-12-21 20:20:00"),
  end_date: Time.zone.parse("2025-12-22 11:30:00"),
  created_at: Time.zone.parse("2025-04-22 13:05:00"),
)

### EUROPE
Plan.find_or_create_by!(
  trip_id: europe.id,
  title: "Train St. Pancras -> Brussels",
  plan_type: Plan.plan_types[:travel_by_train],
  start_location_name: "St Pancras International Station, London, United Kingdom",
  start_location_latitude: 51.53193075,
  start_location_longitude: -0.12665709611650397,
  end_location_name: "Gare Centrale - Centraal Station, Brussels, Belgium",
  end_location_latitude: 50.84652885,
  end_location_longitude: 4.35873316230882,
  start_date: Time.zone.parse("2026-08-01 09:54:00"),
  end_date: Time.zone.parse("2026-08-01 14:30:00"),
  created_at: Time.zone.parse("2025-04-15 19:05:00"),
)

Plan.find_or_create_by!(
  trip_id: europe.id,
  title: "Train Brussels -> Köln Hbf.",
  plan_type: Plan.plan_types[:travel_by_train],
  start_location_name: "Gare Centrale - Centraal Station, Brussels, Belgium",
  start_location_latitude: 50.84652885,
  start_location_longitude: 4.35873316230882,
  end_location_name: "Köln Hauptbahnhof, Cologne, Germany",
  end_location_latitude: 50.94241055,
  end_location_longitude: 6.958275091716306,
  start_date: Time.zone.parse("2026-08-01 15:00:00"),
  end_date: Time.zone.parse("2026-08-01 17:30:00"),
  created_at: Time.zone.parse("2025-04-15 19:05:00"),
)

Plan.find_or_create_by!(
  trip_id: europe.id,
  title: "Look at the cathedral",
  plan_type: Plan.plan_types[:sightseeing],
  start_location_name: "Cologne Cathedral, Cologne, Germany",
  start_location_latitude: 50.941303500000004,
  start_location_longitude: 6.958137997831819,
  start_date: Time.zone.parse("2026-08-02 11:15:00"),
  end_date: Time.zone.parse("2026-08-02 12:30:00"),
  created_at: Time.zone.parse("2025-04-15 18:05:00"),
)

Plan.find_or_create_by!(
  trip_id: europe.id,
  title: "Train Vienna -> Stuttgart",
  plan_type: Plan.plan_types[:travel_by_train],
  start_location_name: "Vienna Central Station, Vienna, Austria",
  start_location_latitude: 48.1849883,
  start_location_longitude: 16.3779391,
  end_location_name: "Stuttgart Main Station, Stuttgart, Germany",
  end_location_latitude: 48.7842663,
  end_location_longitude: 9.1821173,
  start_date: Time.zone.parse("2026-08-15 09:15:00"),
  end_date: Time.zone.parse("2026-08-15 12:30:00"),
  created_at: Time.zone.parse("2025-04-17 13:05:00"),
)

Plan.find_or_create_by!(
  trip_id: europe.id,
  title: "Train Stuttgart -> Paris",
  plan_type: Plan.plan_types[:travel_by_train],
  start_location_name: "Stuttgart Main Station, Stuttgart, Germany",
  start_location_latitude: 48.7842663,
  start_location_longitude: 9.1821173,
  end_location_name: "Paris Gare de l’Est, Paris, France",
  end_location_latitude: 48.8770979,
  end_location_longitude: 2.3594905,
  start_date: Time.zone.parse("2026-08-15 13:00:00"),
  end_date: Time.zone.parse("2026-08-15 17:30:00"),
  created_at: Time.zone.parse("2025-04-17 13:05:00"),
)

Plan.find_or_create_by!(
  trip_id: europe.id,
  title: "Train Paris -> London",
  plan_type: Plan.plan_types[:travel_by_train],
  start_location_name: "Paris Gare de l’Est, Paris, France",
  start_location_latitude: 48.8770979,
  start_location_longitude: 2.3594905,
  end_location_name: "St Pancras International Station, London, United Kingdom",
  end_location_latitude: 51.53193075,
  end_location_longitude: -0.12665709611650397,
  start_date: Time.zone.parse("2026-08-15 19:00:00"),
  end_date: Time.zone.parse("2026-08-15 22:30:00"),
  created_at: Time.zone.parse("2025-04-17 16:05:00"),
)
