# frozen_string_literal: true

# Decorator for questions/reviews
class ManagementItemDecorator < ApplicationDecorator
  delegate_all

  def first_in_order
    object.order == 1
  end

  def last_in_order
    object.order == object.class.maximum(:order)
  end

  def order_path
    Rails.application.routes.url_helpers.send("order_api_#{object.class.name.downcase}_path".to_sym, object)
  end

  def visibility_path
    Rails.application.routes.url_helpers.send("visibility_api_#{object.class.name.downcase}_path".to_sym, object)
  end

  def question?
    object.class.name == "Question"
  end

  def review?
    object.class.name == "Review"
  end
end
