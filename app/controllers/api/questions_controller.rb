# frozen_string_literal: true

module Api
  # Handles the creation of questions
  class QuestionsController < ApplicationController
    include Streamable
    include AdminItemManageable

    attr_reader :model, :type, :path

    def create
      question = Question.new(question_params)

      if question.save
        session.delete(:question_data)

        stream_response(
          streams: turbo_stream.replace(
            "new_question",
            partial: "questions/form",
            locals: { question: Question.new, errors: nil },
          ),
          message: { content: "Your question has been submitted.", type: "success" },
          redirect_path: faq_path,
        )
      else
        flash[:errors] = question.errors.to_hash(true)
        session[:question_data] = question.attributes.slice("question")

        stream_response(
          streams: turbo_stream.replace(
            "new_question",
            partial: "questions/form",
            locals: { question: question, errors: question.errors.to_hash(true) },
          ),
          redirect_path: faq_path,
        )
      end
    end

    def answer
      question = Question.find(params[:id])

      if question&.update(answer: params[:answer])
        stream_response(
          streams: turbo_stream.replace(
            "answer-form-#{question.id}",
            partial: "questions/answer_form",
            locals: { item: question.decorate },
          ),
          message: { content: "Answer saved successfully.", type: "success" },
          redirect_path: manage_admin_questions_path,
        )
      else
        admin_item_stream_error_response("An error occurred while trying to update question answer.")
      end
    end

    def visibility
      if AdminManagement::VisibilityUpdater.call(Question, params[:id])
        admin_item_stream_success_response(Question.visible, Question.hidden, manage_admin_questions_path)
      else
        admin_item_stream_error_response(
          "An error occurred while trying to update question visibility.",
          manage_admin_questions_path,
        )
      end
    end

    def order
      if AdminManagement::OrderUpdater.call(Question, params[:id], params[:order_change].to_i)
        admin_item_stream_success_response(Question.visible, Question.hidden, manage_admin_questions_path)
      else
        admin_item_stream_error_response(
          "An error occurred while trying to update question order.",
          manage_admin_questions_path,
        )
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
