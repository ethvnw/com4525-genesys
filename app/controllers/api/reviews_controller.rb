# frozen_string_literal: true

module Api
  # Handles the creation of reviews
  class ReviewsController < ApplicationController
    include Streamable
    include AdminItemManageable

    before_action :set_instance_variables
    attr_reader :model, :type, :path

    def create
      review = Review.new(review_params)

      if review.save
        session.delete(:review_data)

        stream_response(
          streams: turbo_stream.replace(
            "new_review",
            partial: "reviews/form",
            locals: { review: Review.new, errors: nil },
          ),
          message: { content: "Review submitted. Thanks for helping to improve Roamio!", type: "success" },
          redirect_path: root_path,
        )
      else
        flash[:errors] = review.errors.to_hash(true)
        session[:review_data] = review.attributes.slice("name", "content")

        stream_response(
          streams: turbo_stream.replace(
            "new_review",
            partial: "reviews/form",
            locals: { review: review, errors: review.errors.to_hash(true) },
          ),
          redirect_path: root_path(anchor: "new_review"),
        )
      end
    end

    def visibility
      update_visibility
    end

    def order
      update_order
    end

    def like
      review = Review.find(params[:id])

      if review.nil?
        flash[:alert] = "An error occurred while trying to like review."

        stream_response(
          message: { content: "An error occurred while trying to like review.", type: "danger" },
          redirect_path: root_path(anchor: "reviews-carousel"),
        )
      else
        if session[:liked_reviews]&.include?(review.id)
          review.decrement!(:engagement_counter)
          session[:liked_reviews].delete(review.id)
        else
          review.increment!(:engagement_counter)
          session[:liked_reviews] ||= []
          session[:liked_reviews] << review.id
        end

        # Replace only the review like button
        stream_response(
          streams: turbo_stream.replace(
            "like-review-#{review.id}",
            partial: "reviews/like_button",
            locals: { review: review },
          ),
          redirect_path: root_path(anchor: "reviews-carousel"),
        )
      end
    end

    private

    def review_params
      params.require(:review).permit(:content, :name)
    end

    def set_instance_variables
      @model = Review
      @type = "review"
      @path = Rails.application.routes.url_helpers.manage_admin_reviews_path
    end
  end
end
