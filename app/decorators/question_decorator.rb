# frozen_string_literal: true

##
# Decorator class for questions
class QuestionDecorator < ManagementItemDecorator
  delegate_all

  ##
  # Returns the question content
  #
  # @return [String] the question content
  def content
    object.question
  end

  ##
  # Returns the question 'subcontent' (the answer)
  #
  # @return [String] the answer content
  def subcontent
    object.answer
  end

  ##
  # Returns the icon that should show for the engagement stats (a click)
  #
  # @return [String] the engagement icon
  def engagement_icon
    "bi-hand-index"
  end
end
