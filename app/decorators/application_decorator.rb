# frozen_string_literal: true

# Contains global decorators used throughout the app
class ApplicationDecorator < Draper::Decorator
  delegate_all

  def formatted_timestamp
    object.created_at.strftime("%B %d, %Y %I:%M %p")
  end

  def formatted_country_name
    country_obj = ISO3166::Country[object.country_code]
    return "" unless country_obj

    "#{country_obj.emoji_flag} #{country_obj.common_name}"
  end

  class << self
    def collection_decorator_class
      PaginatingDecorator
    end
  end
end
