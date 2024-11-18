# frozen_string_literal: true

# Contains global decorators used throughout the app
class ApplicationDecorator < Draper::Decorator
  delegate_all

  class << self
    def collection_decorator_class
      PaginatingDecorator
    end
  end
end
