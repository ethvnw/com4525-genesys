# frozen_string_literal: true

# Handles the creation of questions
class QuestionsController < ApplicationController
  def create
    @question = Question.new(question_params)

    # If you want to quickly test adding a question, set is_hidden to false so it automatically shows up on the FAQ
    @question.is_hidden = true
    @question.engagement_counter = 0

    unless @question.save
      flash[:errors] = @question.errors.full_messages
      flash[:question_data] = @question.attributes.slice("question", "answer")
    end
    redirect_to(faq_path)
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
    json = JSON.parse(params[:items])
    json.each do |id, order|
      Question.find(id).update(order: order)
    end
    head(:ok)
  end

  def answer
    @question = Question.find(params[:id])
    # Update the answer for the question and respond depending on if an error occurred
    if @question.update(answer: params[:answer])
      # If the update is successful, respond with the answer
      respond_to do |format|
        format.json { render(json: { answer: @question.answer }, status: :ok) }
        format.html { redirect_to(admin_manage_questions_path, notice: "Answer saved successfully.") }
      end
    else
      # If the update fails, respond with the full error messages
      respond_to do |format|
        format.json { render(json: { error: @question.errors.full_messages }, status: :unprocessable_entity) }
        format.html { redirect_to(admin_manage_questions_path, alert: "Failed to save answer.") }
      end
    end
  end

  private

  def question_params
    params.require(:question).permit(:question)
  end
end
