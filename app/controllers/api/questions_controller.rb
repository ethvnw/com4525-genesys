# frozen_string_literal: true

module Api
  # Handles the creation of questions
  class QuestionsController < ApplicationController
    def create
      @question = Question.new(question_params)

      # If you want to quickly test adding a question, set is_hidden to false so it automatically shows up on the FAQ
      @question.is_hidden = true
      @question.engagement_counter = 0

      if @question.save
        session.delete(:question_data)
        redirect_to(faq_path, notice: "Your question has been submitted.")
      else
        flash[:errors] = @question.errors.full_messages
        session[:question_data] = @question.attributes.slice("question")
        redirect_to(faq_path)
      end
    end

    def visibility
      @question = Question.find(params[:id])
      @question.toggle!(:is_hidden)
      @question.update(order: params[:order])
      head(:ok)
    end

    def orders
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
          format.html { redirect_to(manage_admin_questions_path, notice: "Answer saved successfully.") }
        end
      end
    end

    def click
      unless user_can_click?(params[:id])
        head(:not_found) and return
      end

      Question.find(params[:id]).increment!(:engagement_counter)
      session[:questions_liked]
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
end
