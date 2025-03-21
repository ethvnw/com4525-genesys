# frozen_string_literal: true

# Provides methods for formatting dates for Trips
class TripDecorator < ApplicationDecorator
  delegate_all

  def formatted_start_date
    format_date_slashes(start_date)
  end

  def formatted_end_date
    format_date_slashes(end_date)
  end

  # Formats the date range to the format (dd - dd mmm: e.g. 01 - 05 Jan)
  def formatted_date_range
    start_date.strftime("%d") + " - " + end_date.strftime("%d %b")
  end
end
