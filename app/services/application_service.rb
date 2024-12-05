# frozen_string_literal: true

# ApplicationService is a base service class, that all others should inherit from.
# It provides some syntactic sugar allowing you to call a method from a service class
# without needing to instantiate it with `.new`.
# Adapted from: https://www.toptal.com/ruby-on-rails/rails-service-objects-tutorial
#
#   class MyService < ApplicationService
#     def call
#       # Implement the service logic here
#     end
#   end
#
#   result = MyService.call(args) # Calls `MyService.new(args).call`
class ApplicationService
  class << self
    def call(*args, &block)
      new(*args, &block).call
    end
  end
end
