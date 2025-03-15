# frozen_string_literal: true

module Api
  # Handles the creation of reviews
  class ReviewsController < ApplicationController
    def create
      @review = Review.new(review_params)
      if @review.save
        session.delete(:review_data)
        redirect_to(root_path, notice: "Thank you for your review!")
      else
        flash[:errors] = @review.errors.to_hash(true)
        session[:review_data] = @review.attributes.slice("name", "content")
        redirect_to(root_path(anchor: "new_review"))
      end
    end

    def like
      @review = Review.find(params[:id])
      params[:like] == "true" ? @review.increment!(:engagement_counter) : @review.decrement!(:engagement_counter)
      head(:ok)
    end

    def visibility
      if AdminManagement::VisibilityUpdater.call(Review, params[:id])
        redirect_to(manage_admin_reviews_path)
      else
        redirect_to(manage_admin_reviews_path, alert: "An error occurred while trying to update review visibility.")
      end
    end

    def order
      if AdminManagement::OrderUpdater.call(Review, params[:id], params[:order_change].to_i)
        redirect_to(manage_admin_reviews_path)
      else
        redirect_to(manage_admin_reviews_path, alert: "An error occurred while trying to update review order.")
      end
    end

    private

    def review_params
      params.require(:review).permit(:content, :name)
    end
  end
end
