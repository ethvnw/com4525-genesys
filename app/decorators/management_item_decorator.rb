# frozen_string_literal: true

# Decorator for questions/reviews
class ManagementItemDecorator < ApplicationDecorator
  delegate_all

  ##
  # Returns true if the item is the first in order (used to determine whether the "move up" button should be shown)
  #
  # @return [Boolean] whether the item is the first in order
  def first_in_order
    object.order == 1
  end

  ##
  # Returns true if the item is the last in order (used to determine whether the "move down" button should be shown)
  #
  # @return [Boolean] whether the item is the last in order
  def last_in_order
    object.order == object.class.maximum(:order)
  end

  ##
  # Returns the path to the order action for the item
  #
  # @return [String] the path to the order action
  def order_path
    # Need to use Rails.application.routes.url_helpers to access path helpers outside of controllers
    Rails.application.routes.url_helpers.send("order_api_#{object.class.name.downcase}_path".to_sym, object)
  end

  ##
  # Returns the path to the visibility action for the item
  #
  # @return [String] the path to the visibility action
  def visibility_path
    Rails.application.routes.url_helpers.send("visibility_api_#{object.class.name.downcase}_path".to_sym, object)
  end

  ##
  # Returns true if the item is a question
  #
  # @return [Boolean] whether the item is a question
  def question?
    object.class.name == "Question"
  end

  ##
  # Returns true if the item is a review
  #
  # @return [Boolean] whether the item is a review
  def review?
    object.class.name == "Review"
  end
end
