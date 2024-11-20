# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# db/seeds.rb

User.create!(
  email: "admin@genesys.com",
  password: "AdminGenesys#1",
  password_confirmation: "AdminGenesys#1",
  user_role: "Admin",
) unless User.exists?(email: "admin@genesys.com")

User.create!(
  email: "reporter@genesys.com",
  password: "ReporterGenesys#1",
  password_confirmation: "ReporterGenesys#1",
  user_role: "Admin",
) unless User.exists?(email: "reporter@genesys.com")
