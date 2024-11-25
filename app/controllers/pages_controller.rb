# frozen_string_literal: true

# A basic controller from the template app
class PagesController < ApplicationController
  def home
    @script_packs = ["home"]

    @review = if flash[:review_data]
      Review.new(flash[:review_data])
    else
      Review.new
    end
    @errors = flash[:errors]
    @reviews = Review.where.not(is_hidden: true).order(order: :asc)

    @question = if flash[:question_data]
      Question.new(flash[:question_data])
    else
      Question.new
    end
    @questions = Question.where.not(is_hidden: true)
  end
end
