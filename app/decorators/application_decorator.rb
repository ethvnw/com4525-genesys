# frozen_string_literal: true

# Handles application decorators, allowing presentation-centric methods to act like model methods
class ApplicationDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
