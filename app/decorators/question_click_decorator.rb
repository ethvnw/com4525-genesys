# frozen_string_literal: true

# Decorator for question clicks
class QuestionClickDecorator < ApplicationDecorator
  delegate_all

  def initialize(*args)
    super
    @question_obj = object.question
  end

  def journey_title
    @question_obj.question
  end

  def journey_header
    "Clicked on Question"
  end

  def journey_icon
    "bi bi-hand-index"
  end
end
