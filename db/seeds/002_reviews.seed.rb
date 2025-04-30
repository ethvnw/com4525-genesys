# frozen_string_literal: true

Review.find_or_create_by!(
  name: "Jack Burke",
  content: "Roamio will make travel planning stress-free! All my tickets,
itineraries, and travel ideas in one place!",
  order: 1,
  is_hidden: false,
)

Review.find_or_create_by!(
  name: "Jack Sanders",
  content: "Roamio's trip timeline will help me to make sure I never forget
about a plan! Amazing!",
  order: 2,
  is_hidden: false,
)

Review.find_or_create_by!(
  name: "James March",
  content: "I can't wait to get reminders about my flights and plans. No more
missed flights for me!",
  order: 3,
  is_hidden: false,
)

Review.find_or_create_by!(
  name: "Kush Bharakhada",
  content: "Roamio will let me finally share my itineraries with my friends!
No more disagreements over plans!",
  order: 4,
  is_hidden: false,
)

Review.find_or_create_by!(
  name: "Ethan Watts",
  content: "Roamio brings all your travel essentials into one place! I can't
wait to keep track of my car hire bookings on here!",
  order: 5,
  is_hidden: false,
)

Review.find_or_create_by!(
  name: "Nina Barker",
  content: "Roamio is my dream app! I can finally stop worrying about losing my
tickets by uploading them here!",
  order: 6,
  is_hidden: false,
)
