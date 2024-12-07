# frozen_string_literal: true

# Decorator for registrations
class RegistrationDecorator < ApplicationDecorator
  delegate_all

  def formatted_country_name
    country_obj = ISO3166::Country[object.country_code]
    return "" unless country_obj

    "#{country_obj.emoji_flag} #{country_obj.common_name}"
  end

  def formatted_timestamp
    # %Month %Day of Month, %Year %Hours%Minutes %AM/PM
    object.created_at.strftime("%B %d, %Y %I:%M %p")
  end
end
