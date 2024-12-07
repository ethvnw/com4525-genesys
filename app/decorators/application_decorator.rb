# frozen_string_literal: true

# Contains global decorators used throughout the app
class ApplicationDecorator < Draper::Decorator
  delegate_all

  def formatted_timestamp
    object.created_at.strftime("%B %d, %Y %I:%M %p")
  end

  class << self
    def collection_decorator_class
      PaginatingDecorator
    end
  end
end
