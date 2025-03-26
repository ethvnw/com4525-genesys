# frozen_string_literal: true

##
# Decorator class for reviews
class ReviewDecorator < ManagementItemDecorator
  delegate_all

  ##
  # Returns the review 'subcontent' (the name)
  #
  # @return [String] the review name
  def subcontent
    object.name
  end

  ##
  # Returns the icon that should show for the engagement stats (a thumbs up)
  #
  # @return [String] the engagement icon
  def engagement_icon
    "bi-hand-thumbs-up"
  end
end
