# frozen_string_literal: true

module Analytics
  # Trip analytics controller
  class ReferralsController < Analytics::BaseController
    include Streamable
    def index
      @referrals = {
        today: Referral.count_today,
        this_week: Referral.count_this_week,
        this_month: Referral.count_this_month,
        all_time: Referral.count,
      }
      # Only get member users, not reporters or admins
      @new_users = {
        today: User.members.count_today,
        this_week: User.members.count_this_week,
        this_month: User.members.count_this_month,
        all_time: User.members.count,
      }

      # Display all users with at least one referral, ordered by the number of referrals
      users = User
        .where("referrals_count > 0")
        .order(referrals_count: :desc, id: :asc)

      @pagy, @users = pagy(users, limit: 25)
      @users.decorate

      stream_response("analytics/referrals")
    end
  end
end
