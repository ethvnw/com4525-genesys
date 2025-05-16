# frozen_string_literal: true

require_relative "seed_helpers"

# Find coords using Bboxfinder [http://bboxfinder.com]
locations = [
  { name: "Sheffield",     country_code_iso: "GB", latitude: 53.376871, longitude: -1.500425 },
  { name: "London",        country_code_iso: "GB", latitude: 51.604225, longitude: -0.066248 },
  { name: "Birmingham",    country_code_iso: "GB", latitude: 52.4288, longitude: -1.9314 },
  { name: "Crawley Down",  country_code_iso: "GB", latitude: 51.120869, longitude: -0.077256 },
  { name: "Leicester",     country_code_iso: "GB", latitude: 52.641911, longitude: -1.143380 },
  { name: "East Grinstead", country_code_iso: "GB", latitude: 51.124004, longitude: -0.006735 },
  { name: "Singapore",     country_code_iso: "SG", latitude: 1.340698, longitude: 103.837444 },
  { name: "New York",      country_code_iso: "US", latitude: 40.7128, longitude: -74.0060 },
  { name: "Paris",         country_code_iso: "FR", latitude: 48.8566, longitude: 2.3522 },
]

locations.each do |location|
  featured = FeaturedLocation.find_or_create_by!(
    name: location[:name],
    country_code_iso: location[:country_code_iso],
    latitude: location[:latitude],
    longitude: location[:longitude],
  )

  seed_location_image(featured, location[:name])
end
