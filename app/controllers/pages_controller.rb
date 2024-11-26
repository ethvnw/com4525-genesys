# frozen_string_literal: true

# A basic controller from the template app
class PagesController < ApplicationController
  def home
    @script_packs = ["application"]
    @style_packs = ["application"]

    @review = if flash[:review_data]
      Review.new(flash[:review_data])
    else
      Review.new
    end
    @errors = flash[:errors]
    @reviews = Review.where.not(is_hidden: true).order(order: :asc)
  end

  def pricing
    @script_packs = ["application"]
    @style_packs = ["application"]
    @errors = flash[:errors]
  end
end
