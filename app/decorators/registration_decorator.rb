# frozen_string_literal: true

# Decorator for registrations
class RegistrationDecorator < ApplicationDecorator
  delegate_all

  def formatted_country_name
    country_obj = ISO3166::Country[object.country_code]
    return "" unless country_obj

    "#{country_obj.emoji_flag} #{country_obj.common_name}"
  end
end
