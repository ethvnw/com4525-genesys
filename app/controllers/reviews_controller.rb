# frozen_string_literal: true

# Handles the creation of reviews
class ReviewsController < ApplicationController
  def new
    redirect_to(root_path)
  end

  def create
    @review = Review.new(review_params)
    if @review.save
    else
      flash[:errors] = @review.errors.full_messages
      flash[:review_data] = @review.attributes.slice("name", "content")
    end
    redirect_to(root_path)
  end

  def update_like_count
    @review = Review.find(params[:id])
    params[:like] == "true" ? @review.increment!(:engagement_counter) : @review.decrement!(:engagement_counter)
    head(:ok)
  end

  private

  def review_params
    params.require(:review).permit(:content, :name)
  end
end
