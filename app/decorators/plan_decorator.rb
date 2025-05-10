# frozen_string_literal: true

# Provides methods for formatting dates and icons for plan views
class PlanDecorator < ApplicationDecorator
  delegate_all
  decorates_association :documents, with: DocumentDecorator

  def single_day?
    start_date == end_date && start_date.present? && end_date.present?
  end

  # Formats the start date to the formats:
  # - "dd" for the same month and year
  # - "dd mmm" for the same year
  # - "dd mmm yyyy  for different years
  # - end date is always formatted as "dd mmm yyyy"
  def formatted_date_range
    unless end_date.present?
      return start_date.strftime("%H:%M %d %b %Y")
    end

    start_date_format = if start_date.year == end_date.year
      if start_date.month == end_date.month
        if start_date.day == end_date.day
          "%H:%M to "
        else
          "%H:%M %d to "
        end
      else
        "%H:%M %d %b to "
      end
    else
      "%H:%M %d %b %Y to "
    end

    start_date.strftime(start_date_format) + end_date.strftime("%H:%M %d %b %Y")
  end

  def formatted_end_date
    return "No end date" unless object.end_date.present?

    if object.start_date.to_date != plan.end_date.to_date
      object.end_date.strftime("%d %B %Y, %H:%M")
    else
      object.end_date.strftime("%H:%M")
    end
  end

  def travel_icon
    case object.plan_type
    when "travel_by_plane"
      "bi bi-airplane-fill"
    when "travel_by_train"
      "bi bi-train-front-fill"
    when "travel_by_bus"
      "bi bi-bus-front-fill"
    when "travel_by_car"
      "bi bi-car-front-fill"
    when "travel_by_boat"
      "bi bi-water"
    when "travel_by_foot"
      "bi bi-person-walking"
    else
      "bi bi-question-circle-fill"
    end
  end

  def view_icon
    case object.plan_type
    when "clubbing", "live_music", /^travel_by_/
      "bi-ticket-detailed-fill"
    when "restaurant"
      "bi-bookmark-dash-fill"
    when "entertainment"
      "bi-emoji-smile-fill"
    when "wellness"
      "bi-heart-pulse-fill"
    when "active"
      "bi-person-arms-up"
    when "sightseeing"
      "bi-camera-fill"
    else
      "bi-receipt"
    end
  end

  def view_label
    case object.plan_type
    when "clubbing", "live_music", "entertainment", /^travel_by_/
      "View Tickets"
    when "restaurant"
      "View Reservation"
    else
      "View Plan"
    end
  end
end
