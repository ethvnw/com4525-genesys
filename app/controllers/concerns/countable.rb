# frozen_string_literal: true

##
# Concern for models that should be countable by day, week, and month (used for analytics pages)
module Countable
  extend ActiveSupport::Concern

  class_methods do
    ##
    # Groups & counts items by day.
    #
    # @return [Hash{Time => Integer}] a hash mapping days to item counts
    def count_by_day
      all.group_by do |item|
        item.created_at.beginning_of_day
      end.transform_values(&:count)
    end

    ##
    # Counts items created today.
    #
    # @return [Integer] the number of items created today.
    def count_today
      count_by_day[Time.current.beginning_of_day] || 0
    end

    ##
    # Groups & counts items by week.
    #
    # @return [Hash{Time => Integer}] a hash mapping week start dates to item counts
    def count_by_week
      all.group_by do |item|
        item.created_at.beginning_of_week
      end.transform_values(&:count)
    end

    ##
    # Counts items created this week.
    #
    # @return [Integer] the number of items created this week.
    def count_this_week
      count_by_week[Time.current.beginning_of_week] || 0
    end

    ##
    # Groups & counts items by month.
    #
    # @return [Hash{Time => Integer}] a hash mapping month start dates to item counts
    def count_by_month
      all.group_by do |item|
        item.created_at.beginning_of_month
      end.transform_values(&:count)
    end

    ##
    # Counts items created this month.
    #
    # @return [Integer] the number of items created this month.
    def count_this_month
      count_by_month[Time.current.beginning_of_month] || 0
    end
  end
end
