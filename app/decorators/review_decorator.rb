# frozen_string_literal: true

##
# Decorator class for reviews
class ReviewDecorator < ManagementItemDecorator
  delegate_all

  def subcontent
    object.name
  end

  def engagement_icon
    "bi-hand-thumbs-up"
  end
end
