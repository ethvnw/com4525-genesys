# frozen_string_literal: true

# Provides methods for formatting the removal of members from trips
class TripMembershipDecorator < ApplicationDecorator
  delegate_all

  def initialize(object, current_user)
    super(object)
    @current_user = current_user
  end

  def button_text
    if object.is_invite_accepted
      if object.user == @current_user
        "Leave"
      else
        "Remove"
      end
    else
      "Cancel"
    end
  end

  def invitation_date_text
    if object.is_invite_accepted
      "Joined on #{object.invite_accepted_date.strftime("%d %b %Y")}"
    else
      "Invited on #{object.created_at.strftime("%d %b %Y")}"
    end
  end
end
