# frozen_string_literal: true

module Admin
  # Questions controller
  class QuestionsController < Admin::BaseController
    def manage
      @script_packs = ["admin_manage_questions"]
      @visible_questions = Question.where(is_hidden: false).order(order: :asc)
      @hidden_questions = Question.where(is_hidden: true).order(order: :asc)
    end
  end
end
