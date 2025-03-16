# frozen_string_literal: true

##
# Decorator class for questions
class QuestionDecorator < ManagementItemDecorator
  delegate_all

  def content
    object.question
  end

  def subcontent
    object.answer
  end

  def engagement_icon
    "bi-hand-index"
  end
end
