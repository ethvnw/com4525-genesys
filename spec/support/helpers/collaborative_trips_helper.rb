# frozen_string_literal: true

##
# Creates and invites a new user to a trip
#
# @param inviter [User] the user who should send the invite
# @param trip [Trip] the trip to invite to
# @param invite_date [Time] the time at which the invite was sent
def invite_new_user_to_trip(inviter, trip, invite_date)
  create(
    :trip_membership,
    sender_user: inviter,
    user: create(:user),
    trip: trip,
    created_at: invite_date,
  )
end
