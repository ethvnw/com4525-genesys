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
end
