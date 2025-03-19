# frozen_string_literal: true

# Provides methods for formatting dates for Trips
class TripDecorator < ApplicationDecorator
  delegate_all

  def format_date(date)
    date.strftime("%d/%m/%Y")
  end

  def formatted_start_date
    format_date(start_date)
  end

  def formatted_end_date
    format_date(end_date)
  end

  def formatted_date_range
    start_date.strftime("%d") + " - " + end_date.strftime("%d %b")
  end
end
