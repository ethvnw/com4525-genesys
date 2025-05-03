# frozen_string_literal: true

module Analytics
  # Trip analytics controller
  class ReferralsController < Analytics::BaseController
    def index
      Time.current
      @referrals = {
        today: Referral.count_today,
        this_week: Referral.count_this_week,
        this_month: Referral.count_this_month,
        all_time: Referral.count,
      }
      @new_users = {
        today: User.count_today,
        this_week: User.count_this_week,
        this_month: User.count_this_month,
        all_time: User.count,
      }

      # Display all users with at least one referral, ordered by the number of referrals
      @users = User
        .left_joins(:referrals)
        .group(:id)
        .select("users.*, COUNT(referrals.id) AS referrals_count")
        .having("COUNT(referrals.id) > 0")
        .order("referrals_count DESC")
        .decorate
    end
  end
end
