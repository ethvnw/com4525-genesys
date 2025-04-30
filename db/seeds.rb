# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require_relative "seeds/seed_helpers"

# db/seeds.rb
if ENV["clear_first"]
  DatabaseCleaner.clean_with(:truncation)
end

##
# Loads all seed files from the seeds directory
# https://blog.magmalabs.io/2019/11/25/best-practices-using-rails-seeds.html
Dir[Rails.root.join("db/seeds/*.seed.rb")].sort.each do |file|
  puts "Processing #{file.split("/").last}"
  require file
end
