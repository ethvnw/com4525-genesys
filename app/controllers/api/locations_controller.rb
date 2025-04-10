# frozen_string_literal: true

module Api
  ##
  # API controller used as a wrapper for the photon location search API.
  # Allows us to easily change location search logic (adding filters etc.) without needing to change the frontend
  class LocationsController < ApplicationController
    def search
      api_response = HTTParty.get(ApiRoutes.location_search(params[:query]), timeout: 5)&.body

      # Set caching headers to allow the browser to cache response from photon
      response.headers["Cache-Control"] = "public, max-age=#{1.hour}"
      render(json: api_response)
    end
  end
end
