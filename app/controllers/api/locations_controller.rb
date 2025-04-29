# frozen_string_literal: true

module Api
  ##
  # API controller used as a wrapper for the photon location search API.
  # Allows us to easily change location search logic (adding filters etc.) without needing to change the frontend
  class LocationsController < ApplicationController
    include Cacheable
    before_action :set_cache_control_headers

    def search
      # Timeout set to 60 to account for when the API throttles the location requests.
      api_response = HTTParty.get(
        ApiRoutes.location_search(params[:query].to_s),
        headers: {
          "User-Agent" => request.headers["User-Agent"],
        },
        timeout: 60,
        uri_adapter: Addressable::URI,
      )&.body
      render(json: api_response)
    end
  end
end
