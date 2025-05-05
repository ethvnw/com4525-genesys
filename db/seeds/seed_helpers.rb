# frozen_string_literal: true

##
# Retrieves a seed image from the images directory inside of the seeds folder
#
# @param image_path [Array<String>] the path of the image, within the seed images directory
# @return [File] the seed image
def seed_image_file(*image_path)
  File.open(Rails.root.join("db", "seeds", "images", *image_path))
end

##
# Seeds an avatar for a given user
#
# @param user [User] the user for which to seed an avatar
# @param filename [String] the filename of the avatar, within db/seeds/images/avatars
def seed_avatar(user, filename)
  user.avatar.attach(
    io: seed_image_file("avatars", filename),
    filename: filename,
    content_type: "image/jpeg",
  )
end

##
# Seeds an avatar for a given user
#
# @param featured_location [FeaturedLocation] the location for which to seed an image
# @param location_name [String] the name of the location, which should match up to an image
def seed_location_image(featured_location, location_name)
  filename = "#{location_name.parameterize.underscore}.webp"

  featured_location.image.attach(
    io: seed_image_file("featured_locations", filename),
    filename: filename,
    content_type: "image/webp",
  )
end

##
# Seeds an image for a given trip
#
# @param trip [Trip] the trip for which to seed an image
# @param filename [String] the filename of the avatar, within db/seeds/images/trips
def seed_trip_image(trip, filename)
  trip.image.attach(
    io: seed_image_file("trips", filename),
    filename: filename,
    content_type: "image/jpeg",
  )
end
