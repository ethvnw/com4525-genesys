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
  end
end
