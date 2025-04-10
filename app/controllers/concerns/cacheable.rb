# frozen_string_literal: true

##
# Concern to allow controllers to override the default 'no cache' config, allowing caching of API responses
module Cacheable
  extend ActiveSupport::Concern

  included do
    ##
    # Set caching headers to allow the browser to cache responses from the server
    #
    # @param max_age [ActiveSupport::Duration] the length of time for which the browser should cache the response
    def set_cache_control_headers(max_age = 1.hour)
      response.headers["Cache-Control"] = "public, max-age=#{max_age}"
      response.headers["Pragma"] = "public"
      response.headers["Expires"] = (Time.zone.now + max_age).httpdate
    end
  end
end
