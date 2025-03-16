# frozen_string_literal: true

module Api
  # Handles the creation of reviews
  class ReviewsController < ApplicationController
    def create
      review = Review.new(review_params)

      respond_to do |format|
        if review.save
          session.delete(:review_data)
          format.turbo_stream do
            flash[:notice] = "Thank you for your review!"
            render(turbo_stream: turbo_stream.action(:redirect, root_path))
          end
        else
          flash[:errors] = review.errors.to_hash(true)
          session[:review_data] = review.attributes.slice("name", "content")
          @review = if session[:review_data]
            Review.new(session[:review_data])
          else
            Review.new
          end
          @errors = flash[:errors]
          format.html { render("reviews/new", status: :unprocessable_entity) }
        end
      end
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

    def like
      review = Review.find(params[:id])

      if review.nil?
        flash[:alert] = "An error occurred while trying to like review."
      elsif session[:liked_reviews]&.include?(review.id)
        review.decrement!(:engagement_counter)
        session[:liked_reviews].delete(review.id)
      else
        review.increment!(:engagement_counter)
        session[:liked_reviews] ||= []
        session[:liked_reviews] << review.id
      end

      respond_to do |format|
        @review = review
        format.html { render("reviews/show") }
      end
    end

    private

    def review_params
      params.require(:review).permit(:content, :name)
    end
  end
end
