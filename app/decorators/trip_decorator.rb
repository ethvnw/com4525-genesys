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

  # Formats the start date to the formats:
  # - "dd" for the same month and year
  # - "dd mmm" for the same year
  # - "dd mmm yyyy  for different years
  # - end date is always formatted as "dd mmm yyyy"
  def formatted_date_range
    start_date_format = if start_date.year == end_date.year
      if start_date.month == end_date.month
        "%d"
      else
        "%d %b"
      end
    else
      "%d %b %Y"
    end

    start_date.strftime(start_date_format) + " - " + end_date.strftime("%d %b %Y")
  end

  def regular_plan_count
    plans.count(&:regular_plan?)
  end

  def travel_plan_count
    plans.count(&:travel_plan?)
  end
end
