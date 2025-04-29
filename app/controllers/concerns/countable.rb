# frozen_string_literal: true

module Countable
  extend ActiveSupport::Concern

  class_methods do
    def count_by_day
      all.group_by do |item|
        item.created_at.beginning_of_day
      end.transform_values(&:count)
    end

    def count_today
      count_by_day[Time.current.beginning_of_day] || 0
    end

    def count_by_week
      all.group_by do |item|
        item.created_at.beginning_of_week
      end.transform_values(&:count)
    end

    def count_this_week
      count_by_week[Time.current.beginning_of_week] || 0
    end

    def count_by_month
      all.group_by do |item|
        item.created_at.beginning_of_month
      end.transform_values(&:count)
    end

    def count_this_month
      count_by_month[Time.current.beginning_of_month] || 0
    end
  end
end
