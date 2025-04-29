# frozen_string_literal: true

# Provides methods for formatting dates and icons for plan views
class ScannableTicketDecorator < ApplicationDecorator
  delegate_all

  def title_value
    object.title == object.code ? "No title" : object.title
  end
end
