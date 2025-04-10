# frozen_string_literal: true

##
# Module which stores all of our API routes in one place, for easier configuration
module ApiRoutes
  class << self
    def location_search(query)
      "https://photon.komoot.io/api?q=#{query}&limit=5"
    end
  end
end
