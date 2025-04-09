# frozen_string_literal: true

# Mailer for trip invitations
class TripMembershipMailer < ApplicationMailer
  def invite_user(trip_membership)
    @trip = trip_membership.trip
    @sender = trip_membership.sender_user
    @recipient = trip_membership.user

    mail(
      to: @recipient.email,
      subject: "#{@sender.username} has invited you to join a trip!",
    )
  end
end
