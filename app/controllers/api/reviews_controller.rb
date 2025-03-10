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
      @review = Review.find(params[:id])
      @review.toggle!(:is_hidden)
      @review.update(order: params[:order])
      head(:ok)
    end

    def orders
      json = JSON.parse(params[:items])
      json.each do |id, order|
        Review.find(id).update(order: order)
      end
      head(:ok)
    end

    private

    def review_params
      params.require(:review).permit(:content, :name)
    end
  end
end
