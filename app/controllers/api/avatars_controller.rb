# frozen_string_literal: true

module Api
  ##
  # Controller for handling user default avatars
  class AvatarsController < ApplicationController
    include Cacheable
    before_action :set_cache_control_headers

    def show
      # Set default username if one isn't found to prevent the default_avatar call from complaining about a nilable type
      username = User.find_by(id: params[:id])&.username || ""

      if username.empty?
        head(:bad_request) and return
      end

      api_response = HTTParty.get(ApiRoutes.default_avatar(username), timeout: 5)
      send_data(api_response.body, type: api_response.content_type, disposition: "inline")
    end
  end
end
