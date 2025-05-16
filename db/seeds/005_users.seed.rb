# frozen_string_literal: true

require_relative "seed_helpers"

# Use create() unless exists?
# As find_or_create_by! will crash due to password field
User.create(
  email: "admin@genesys.com",
  username: "admin1",
  password: "AdminGenesys#1",
  password_confirmation: "AdminGenesys#1",
  user_role: User.user_roles[:admin],
  invitation_accepted_at: Time.zone.parse("2024-06-17 14:23:36"),
) unless User.find_by(email: "admin@genesys.com").present? \
  || User.find_by(username: "admin1").present?

User.create(
  email: "reporter@genesys.com",
  username: "reporter1",
  password: "ReporterGenesys#1",
  password_confirmation: "ReporterGenesys#1",
  user_role: User.user_roles[:reporter],
  invitation_accepted_at: Time.zone.parse("2024-09-03 08:45:12"),
) unless User.find_by(email: "reporter@genesys.com").present? \
  || User.find_by(username: "reporter1").present?

User.create(
  email: "kbharakhada1@sheffield.ac.uk",
  username: "barracuda",
  password: "KBGenesys12!",
  password_confirmation: "KBGenesys12!",
  user_role: User.user_roles[:member],
  invitation_accepted_at: Time.zone.parse("2024-11-22 19:36:45"),
) unless User.find_by(email: "kbharakhada1@sheffield.ac.uk").present? \
  || User.find_by(username: "barracuda").present?

sanders = User.create(
  email: "jsanders4@sheffield.ac.uk",
  username: "jacksanders",
  password: "JSGenesys12!",
  password_confirmation: "JSGenesys12!",
  user_role: User.user_roles[:member],
  invitation_accepted_at: Time.zone.parse("2024-08-30 02:17:51"),
) unless User.find_by(email: "jsanders4@sheffield.ac.uk").present? \
  || User.find_by(username: "jacksanders").present?

seed_avatar(sanders, "sanders.jpg") unless sanders.nil?

burke = User.create(
  email: "REMOVEDke5@sheffield.ac.uk",
  username: "jackburke",
  password: "JBGenesys12!",
  password_confirmation: "JBGenesys12!",
  user_role: User.user_roles[:member],
  invitation_accepted_at: Time.zone.parse("2025-01-14 11:09:27"),
) unless User.find_by(email: "REMOVEDke5@sheffield.ac.uk").present? \
  || User.find_by(username: "jackburke").present?

seed_avatar(burke, "burke.jpg") unless burke.nil?

james = User.create(
  email: "jmarch2@sheffield.ac.uk",
  username: "jamesmarch",
  password: "JMGenesys12!",
  password_confirmation: "JMGenesys12!",
  user_role: User.user_roles[:member],
  invitation_accepted_at: Time.zone.parse("2024-05-26 15:42:08"),
) unless User.find_by(email: "jmarch2@sheffield.ac.uk").present? \
  || User.find_by(username: "jamesmarch").present?

seed_avatar(james, "march.jpg") unless james.nil?

User.create(
  email: "ebarker5@sheffield.ac.uk",
  username: "ninabarker",
  password: "NBGenesys12!",
  password_confirmation: "NBGenesys12!",
  user_role: User.user_roles[:member],
  invitation_accepted_at: Time.zone.parse("2025-02-08 21:33:40"),
) unless User.find_by(email: "ebarker5@sheffield.ac.uk").present? \
    || User.find_by(username: "ninabarker").present?

User.create(
  email: "eawatts1@sheffield.ac.uk",
  username: "ethanwatts",
  password: "EWGenesys12!",
  password_confirmation: "EWGenesys12!",
  user_role: User.user_roles[:member],
  invitation_accepted_at: Time.zone.parse("2024-07-19 05:58:22"),
) unless User.find_by(email: "eawatts1@sheffield.ac.uk").present? \
  || User.find_by(username: "ethanwatts").present?

genesys = User.create(
  email: "epigenesys@demo.com",
  username: "genesys_demo_user",
  password: "EpiGenesys12!",
  password_confirmation: "EpiGenesys12!",
  user_role: User.user_roles[:member],
  invitation_accepted_at: Time.zone.parse("2024-05-26 15:42:08"),
) unless User.find_by(email: "epigenesys@demo.com").present? \
  || User.find_by(username: "genesys_demo_user").present?

seed_avatar(genesys, "genesys.jpg") unless genesys.nil?
