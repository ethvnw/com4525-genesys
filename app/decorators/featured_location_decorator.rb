# frozen_string_literal: true

##
# Decorator for featured locations
class FeaturedLocationDecorator < ApplicationDecorator
  delegate_all

  def trip_name
    "Trip to #{object.name}"
  end

  def location_name
    "#{object.name}, #{object.country_code_iso}"
  end

  # Returns the common name of a country
  # If the common name exceeds the specified maximum length,
  # it falls back to using the country's ISO alpha2 code instead
  # @param max_length [Integer] the maximum allowed length for the country name
  # @return [String] the common country name or ISO alpha2 code
  def truncated_country_name(max_length)
    country_obj = ISO3166::Country[object.country_code_iso]
    if country_obj.common_name.size >= max_length
      return country_obj.alpha2
    end

    country_obj.common_name
  end
end
