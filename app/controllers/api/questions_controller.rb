# frozen_string_literal: true

module Api
  # Handles the creation of questions
  class QuestionsController < ApplicationController
    include Streamable
    include AdminItemManageable

    def create
      @question = Question.new(question_params)
      message = nil

      if @question.save
        session.delete(:question_data)
        @question = Question.new
        message = { content: "Your question has been submitted.", type: "success" }
      else
        flash[:errors] = @question.errors.to_hash(true)
        session[:question_data] = @question.attributes.slice("question")
      end

      stream_response("questions/create", faq_path, message)
    end

    def answer
      @question = Question.find(params[:id])

      if @question&.update(answer: params[:answer])
        message = { content: "Your answer has been submitted.", type: "success" }
        stream_response("questions/answer", manage_admin_questions_path, message)
      else
        respond_with_toast(
          { content: "An error occurred while trying to update question answer.", type: "danger" },
          manage_admin_questions_path,
        )
      end
    end

    def visibility
      if AdminManagement::VisibilityUpdater.call(Question, params[:id])
        admin_item_stream_success_response(Question.visible, Question.hidden, manage_admin_questions_path)
      else
        respond_with_toast(
          { content: "An error occurred while trying to update question visibility.", type: "danger" },
          manage_admin_questions_path,
        )
      end
    end

    def order
      if AdminManagement::OrderUpdater.call(Question, params[:id], params[:order_change].to_i)
        admin_item_stream_success_response(Question.visible, Question.hidden, manage_admin_questions_path)
      else
        respond_with_toast(
          { content: "An error occurred while trying to update question order.", type: "danger" },
          manage_admin_questions_path,
        )
      end
    end

    def click
      unless user_can_click?(params[:id])
        # Return ok instead of not found to avoid console errors
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
    # @param question_id [ActionController::Parameters] the ID of the question to check for validity
    # @return [Boolean] true if current user can click, else false
    def user_can_click?(question_id)
      Question.exists?(id: question_id) && !session[:questions_clicked]&.include?(question_id)
    end
  end
end
