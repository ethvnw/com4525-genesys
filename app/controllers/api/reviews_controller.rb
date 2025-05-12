# frozen_string_literal: true

module Api
  # Handles the creation of reviews
  class ReviewsController < ApplicationController
    include Streamable
    include AdminItemManageable

    def create
      @review = Review.new(review_params)
      message = nil

      if @review.save
        session.delete(:review_data)
        @review = Review.new
        message = {
          content: "Review submitted and waiting for approval. Thanks for helping to improve Roamio!",
          type: "success",
        }
        redirect_path = root_path
      else
        flash[:errors] = @review.errors.to_hash(true)
        session[:review_data] = @review.attributes.slice("name", "content")
        redirect_path = root_path(anchor: "new_review")
      end

      stream_response("reviews/create", redirect_path, message)
    end

    def visibility
      if AdminManagement::VisibilityUpdater.call(Review, params[:id])
        admin_item_stream_success_response(Review.visible, Review.hidden, manage_admin_reviews_path)
      else
        respond_with_toast(
          { content: "An error occurred while trying to update review visibility.", type: "danger" },
          manage_admin_reviews_path,
        )
      end
    end

    def order
      if AdminManagement::OrderUpdater.call(Review, params[:id], params[:order_change].to_i)
        admin_item_stream_success_response(Review.visible, Review.hidden, manage_admin_reviews_path)
      else
        respond_with_toast(
          { content: "An error occurred while trying to update review order.", type: "danger" },
          manage_admin_reviews_path,
        )
      end
    end

    def like
      @review = Review.find(params[:id])

      if @review.nil?
        message = { content: "An error occurred while trying to like review.", type: "danger" }
        respond_with_toast(message, root_path(anchor: "reviews-carousel"))
      else
        if session[:liked_reviews]&.include?(@review.id)
          @review.decrement!(:engagement_counter)
          session[:liked_reviews].delete(@review.id)
        else
          @review.increment!(:engagement_counter)
          session[:liked_reviews] ||= []
          session[:liked_reviews] << @review.id
        end

        # Replace only the review like button
        stream_response("reviews/like", root_path(anchor: "reviews-carousel"))
      end
    end

    private

    def review_params
      params.require(:review).permit(:content, :name)
    end
  end
end
