# frozen_string_literal: true

##
# Module which stores all of our API routes in one place, for easier configuration
module ApiRoutes
  class << self
    ##
    # Returns the URL for the user's default avatar.
    #
    # @param username [String] the username which should be used to create a hash, to seed the avatar generation
    # @return [String] the user avatar URL
    def default_avatar(username)
      # Thumbs by DiceBear, licensed under CC0 1.0. [https://www.dicebear.com]
      "https://api.dicebear.com/9.x/thumbs/svg?seed=#{Digest::MD5.hexdigest(username)}"
    end

    ##
    # Builds a URL for the location search API
    #
    # @param query [String] the user query to send to photon
    # @return [String] the URL which should be called to make the API request
    def location_search(query)
      "https://photon.komoot.io/api?q=#{query}&limit=5"
    end

    ##
    # Builds a Mapbox tile URL for use with Leaflet
    #
    # @param x [Integer] tile X coordinate
    # @param y [Integer] tile Y coordinate
    # @param z [Integer] zoom level
    # @return [String] the URL pointing to the tile image
    def map_tile(x, y, z)
      username = Rails.application.credentials.dig(:mapbox, :username)
      access_token = Rails.application.credentials.dig(:mapbox, :access_token)
      style_id = "cluwv2hsr002a01pj4vm6fojt"

      "https://api.mapbox.com/styles/v1/#{username}/#{style_id}/tiles/256/#{z}/#{x}/#{y}@2x?access_token=#{access_token}"
    end
  end
end
