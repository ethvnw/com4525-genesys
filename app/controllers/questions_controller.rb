# frozen_string_literal: true

# Handles the creation of questions
class QuestionsController < ApplicationController
  def new
    redirect_to(root_path)
  end

  def create
    @question = Question.new(question_params)

    # default values for the question
    # for testing, you can change is_hidden to false so the questions immediately appear on the landing page
    @question.is_hidden = true
    @question.engagement_counter = 0

    if @question.save
    else
      flash[:errors] = @question.errors.full_messages
      flash[:question_data] = @question.attributes.slice("question", "answer")
    end
    redirect_to(root_path)
  end

  def update_like_count
    @question = Question.find(params[:id])
    params[:like] == "true" ? @question.increment!(:engagement_counter) : @question.decrement!(:engagement_counter)
    head(:ok)
  end

  def update_visibility
    @question = Question.find(params[:id])
    @question.toggle!(:is_hidden)
    @question.update(order: params[:order])
    head(:ok)
  end

  def update_orders
    json = JSON.parse(params[:questions])
    json.each do |id, order|
      Question.find(id).update(order: order)
    end
    head(:ok)
  end

  private

  def question_params
    params.require(:question).permit(:question)
  end
end
