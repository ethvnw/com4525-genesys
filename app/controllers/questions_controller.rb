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
      flash[:question_data] = @question.attributes.slice("question")
    end
    redirect_to(faq_path)
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
    end
  end

  def update_click_count
    # Only update click count if user has not already clicked on this question
    # Avoids double counting
    unless user_can_click?(params[:id])
      head(:ok) and return
    end

    Question.find(params[:id]).increment!(:engagement_counter)

    unless session[:questions_liked].present?
      session[:questions_liked] = []
    end

    session[:questions_liked].push(params[:id])

    head(:ok)
  end

  private

  def question_params
    params.require(:question).permit(:question)
  end

  ##
  # Checks that a question exists, and that the user has not already clicked on this question
  # @param [ActionController::Parameters] question_id the ID of the question to check for validity
  # @return [Boolean] true if current user can click, else false
  def user_can_click?(question_id)
    Question.exists?(id: question_id) && !session[:questions_liked]&.include?(question_id)
  end
end
