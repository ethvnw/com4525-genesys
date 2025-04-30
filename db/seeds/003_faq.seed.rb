# frozen_string_literal: true

Question.find_or_create_by!(
  question: "How do I upload tickets and bookings to the app?",
  answer: "You can upload tickets and booking through either barcode scanning or manual entry.",
  is_hidden: false,
  engagement_counter: 3,
  order: 1,
)

Question.find_or_create_by!(
  question: "Can I organise group trips with friends or family?",
  answer: "Yes! Roamio supports both solo and group trips.",
  is_hidden: false,
  engagement_counter: 2,
  order: 2,
)

Question.find_or_create_by!(
  question: "Can I go back and edit my plans if I make a mistake?",
  is_hidden: true,
  engagement_counter: 0,
  order: -1,
)
