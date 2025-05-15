# frozen_string_literal: true

##
# Concern for models that should be countable by day, week, and month (used for analytics pages)
module Countable
  extend ActiveSupport::Concern

  class_methods do
    ##
    # Counts items created today.
    #
    # @return [Integer] the number of items created today.
    def count_today
      where("DATE_TRUNC('day', created_at) = ?", Time.current.beginning_of_day).count
    end

    ##
    # Counts items created this week.
    #
    # @return [Integer] the number of items created this week.
    def count_this_week
      where("DATE_TRUNC('week', created_at) = ?", Time.current.beginning_of_week).count
    end

    ##
    # Counts items created this month.
    #
    # @return [Integer] the number of items created this month.
    def count_this_month
      where("DATE_TRUNC('month', created_at) = ?", Time.current.beginning_of_month).count
    end
  end
end
