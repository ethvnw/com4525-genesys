# frozen_string_literal: true

# Decorator for question clicks
class QuestionClickDecorator < ApplicationDecorator
  delegate_all

  def journey_title
    question_obj = object.question
    question_obj.question
  end
end
