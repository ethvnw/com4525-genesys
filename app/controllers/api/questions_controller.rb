# frozen_string_literal: true

module Api
  # Handles the creation of questions
  class QuestionsController < ApplicationController
    def create
      question = Question.new(question_params)

      if question.save
        session.delete(:question_data)
        redirect_to(faq_path, notice: "Your question has been submitted.")
      else
        flash[:errors] = question.errors.to_hash(true)
        session[:question_data] = question.attributes.slice("question")
        redirect_to(faq_path)
      end
    end

    def visibility
      if AdminManagement::VisibilityUpdater.call(Question, params[:id])
        redirect_to(manage_admin_questions_path)
      else
        redirect_to(manage_admin_questions_path, alert: "An error occurred while trying to update question visibility.")
      end
    end

    def order
      if AdminManagement::OrderUpdater.call(Question, params[:id], params[:order_change].to_i)
        redirect_to(manage_admin_questions_path)
      else
        redirect_to(manage_admin_questions_path, alert: "An error occurred while trying to update question order.")
      end
    end

    def answer
      question = Question.find(params[:id])
      # Update the answer for the question and respond depending on if an error occurred
      if question.update(answer: params[:answer])
        redirect_to(manage_admin_questions_path, notice: "Answer saved successfully.")
      end
    end

    def click
      unless user_can_click?(params[:id])
        head(:ok) and return
      end

      Question.find(params[:id]).increment!(:engagement_counter)
      unless session[:questions_clicked].present?
        session[:questions_clicked] = []
      end

      session[:questions_clicked].push(params[:id])

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
      Question.exists?(id: question_id) && !session[:questions_clicked]&.include?(question_id)
    end
  end
end
