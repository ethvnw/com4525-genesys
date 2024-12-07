# frozen_string_literal: true

# Decorator for review likes
class ReviewLikeDecorator < ApplicationDecorator
  delegate_all

  def journey_title
    review_obj = object.review
    review_obj.content
  end
end
