# frozen_string_literal: true

# Decorator for review likes
class ReviewLikeDecorator < ApplicationDecorator
  delegate_all

  def initialize(*args)
    super
    @review_obj = object.review
  end

  def journey_title
    @review_obj.content
  end

  def journey_header
    "Liked Review"
  end

  def journey_icon
    "bi bi-hand-thumbs-up"
  end
end
