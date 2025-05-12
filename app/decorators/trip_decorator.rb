# frozen_string_literal: true

# Provides methods for formatting dates for Trips
class TripDecorator < ApplicationDecorator
  delegate_all

  def single_day?
    start_date.to_date == end_date.to_date && start_date.present? && end_date.present?
  end

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
    if single_day?
      return start_date.strftime("#{start_date.day.ordinalize} %b %Y")
    end

    start_date_format = if start_date.year == end_date.year
      if start_date.month == end_date.month
        start_date.day.ordinalize
      else
        "#{start_date.day.ordinalize} %b"
      end
    else
      "#{start_date.day.ordinalize} %b %Y"
    end

    start_date.strftime(start_date_format) + " - " + end_date.day.ordinalize + end_date.strftime(" %b %Y")
  end

  ##
  # Converts the trip image to webp format, resizes it, and provides the URL for that variant
  # Improves application performance by minimising data transfer to the client
  # @return [ActiveStorage::Variant, nil] the transformed trip image
  def webp_image
    image&.variant(resize_to_limit: [1000, 1000], convert: :webp, format: :webp)
  end
end
