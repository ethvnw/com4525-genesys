# frozen_string_literal: true

module Api
  ##
  # API controller used as a wrapper for Mapbox API
  class MapController < ApplicationController
    include Cacheable
    before_action :set_cache_control_headers

    def tile
      api_response = HTTParty.get(ApiRoutes.map_tile(params[:x].to_s, params[:y].to_s, params[:z].to_s))
      send_data(api_response.body, type: api_response.content_type, disposition: "inline")
    end
  end
end
