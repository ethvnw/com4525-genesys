# frozen_string_literal: true

module Admin
  # Reviews controller
  class ReviewsController < Admin::BaseController
    def manage
      @visible_reviews = Review.where(is_hidden: false).order(order: :asc)
      @hidden_reviews = Review.where(is_hidden: true).order(order: :asc)
    end
  end
end
