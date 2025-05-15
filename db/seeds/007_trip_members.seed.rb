# frozen_string_literal: true

ew = User.find_by(email: "eawatts1@sheffield.ac.uk") || User.find_by(username: "ethanwatts")
nb = User.find_by(email: "ebarker5@sheffield.ac.uk") || User.find_by(username: "ninabarker")
jb = User.find_by(email: "jburke5@sheffield.ac.uk") || User.find_by(username: "jackburke")
jm = User.find_by(email: "jmarch2@sheffield.ac.uk") || User.find_by(username: "jamesmarch")
js = User.find_by(email: "jsanders4@sheffield.ac.uk") || User.find_by(username: "jacksanders")
kb = User.find_by(email: "kbharakhada1@sheffield.ac.uk") || User.find_by(username: "barracuda")

brienz = Trip.find_by(title: "Switzerland Summer '25")
brighton = Trip.find_by(title: "Beach Weekend Getaway")
sheffield = Trip.find_by(title: "Graduation!")
australia = Trip.find_by(title: "Australian Adventure")
europe = Trip.find_by(title: "Summer Interrailing")

### BRIENZ
TripMembership.find_or_create_by!(
  trip_id: brienz.id,
  user_id: js.id,
  sender_user_id: js.id,
  is_invite_accepted: true,
  invite_accepted_date: brienz.created_at,
  user_display_name: js.username,
)

### BRIGHTON
TripMembership.find_or_create_by!(
  trip_id: brighton.id,
  user_id: jb.id,
  sender_user_id: jb.id,
  is_invite_accepted: true,
  created_at: brighton.created_at,
  invite_accepted_date: brighton.created_at,
  user_display_name: jb.username,
)

TripMembership.find_or_create_by!(
  trip_id: brighton.id,
  user_id: kb.id,
  sender_user_id: jb.id,
  is_invite_accepted: false,
  created_at: brighton.created_at + 2.days,
)

### SHEFFIELD
TripMembership.find_or_create_by!(
  trip_id: sheffield.id,
  user_id: js.id,
  sender_user_id: js.id,
  is_invite_accepted: true,
  created_at: sheffield.created_at,
  invite_accepted_date: sheffield.created_at,
  user_display_name: "sanders",
)

TripMembership.find_or_create_by!(
  trip_id: sheffield.id,
  user_id: jb.id,
  sender_user_id: js.id,
  is_invite_accepted: true,
  created_at: sheffield.created_at + 2.days + 1.minute,
  invite_accepted_date: sheffield.created_at + 2.days + 5.hours,
  user_display_name: "burke",
)

TripMembership.find_or_create_by!(
  trip_id: sheffield.id,
  user_id: kb.id,
  sender_user_id: js.id,
  is_invite_accepted: true,
  created_at: sheffield.created_at + 2.days + 2.minutes,
  invite_accepted_date: sheffield.created_at + 2.days + 1.hour + 31.minutes,
  user_display_name: kb.username,
)

TripMembership.find_or_create_by!(
  trip_id: sheffield.id,
  user_id: jm.id,
  sender_user_id: js.id,
  is_invite_accepted: true,
  created_at: sheffield.created_at + 2.days + 3.minute,
  invite_accepted_date: sheffield.created_at + 3.days + 39.minutes,
  user_display_name: jm.username,
)

TripMembership.find_or_create_by!(
  trip_id: sheffield.id,
  user_id: nb.id,
  sender_user_id: js.id,
  is_invite_accepted: true,
  created_at: sheffield.created_at + 2.days + 4.minute,
  invite_accepted_date: sheffield.created_at + 2.days + 3.hours,
  user_display_name: nb.username,
)

TripMembership.find_or_create_by!(
  trip_id: sheffield.id,
  user_id: ew.id,
  sender_user_id: js.id,
  is_invite_accepted: true,
  created_at: sheffield.created_at + 2.days + 5.minutes,
  invite_accepted_date: sheffield.created_at + 2.days + 7.minutes,
  user_display_name: ew.username,
)

### AUSTRALIA
TripMembership.find_or_create_by!(
  trip_id: australia.id,
  user_id: ew.id,
  sender_user_id: ew.id,
  is_invite_accepted: true,
  created_at: australia.created_at,
  invite_accepted_date: australia.created_at,
  user_display_name: ew.username,
)

TripMembership.find_or_create_by!(
  trip_id: australia.id,
  user_id: nb.id,
  sender_user_id: nb.id,
  is_invite_accepted: true,
  created_at: australia.created_at + 5.days,
  invite_accepted_date: australia.created_at + 7.days,
  user_display_name: nb.username,
)

TripMembership.find_or_create_by!(
  trip_id: australia.id,
  user_id: kb.id,
  sender_user_id: nb.id,
  is_invite_accepted: false,
  created_at: australia.created_at + 8.days,
)

TripMembership.find_or_create_by!(
  trip_id: australia.id,
  user_id: jm.id,
  sender_user_id: ew.id,
  is_invite_accepted: false,
  created_at: australia.created_at + 9.days,
)

TripMembership.find_or_create_by!(
  trip_id: australia.id,
  user_id: js.id,
  sender_user_id: ew.id,
  is_invite_accepted: false,
  created_at: australia.created_at + 10.days,
)

TripMembership.find_or_create_by!(
  trip_id: australia.id,
  user_id: jb.id,
  sender_user_id: nb.id,
  is_invite_accepted: false,
  created_at: australia.created_at + 11.days,
)

### EUROPE
TripMembership.find_or_create_by!(
  trip_id: europe.id,
  user_id: jm.id,
  sender_user_id: jm.id,
  is_invite_accepted: true,
  created_at: europe.created_at,
  invite_accepted_date: europe.created_at,
  user_display_name: jm.username,
)

TripMembership.find_or_create_by!(
  trip_id: europe.id,
  user_id: kb.id,
  sender_user_id: jm.id,
  is_invite_accepted: false,
  created_at: europe.created_at + 1.day,
)

TripMembership.find_or_create_by!(
  trip_id: europe.id,
  user_id: js.id,
  sender_user_id: jm.id,
  is_invite_accepted: false,
  created_at: europe.created_at + 1.day,
)

TripMembership.find_or_create_by!(
  trip_id: europe.id,
  user_id: jb.id,
  sender_user_id: jm.id,
  is_invite_accepted: false,
  created_at: europe.created_at + 1.day,
)

TripMembership.find_or_create_by!(
  trip_id: europe.id,
  user_id: nb.id,
  sender_user_id: jm.id,
  is_invite_accepted: false,
  created_at: europe.created_at + 1.day,
)

TripMembership.find_or_create_by!(
  trip_id: europe.id,
  user_id: ew.id,
  sender_user_id: jm.id,
  is_invite_accepted: false,
  created_at: europe.created_at + 1.day,
)
