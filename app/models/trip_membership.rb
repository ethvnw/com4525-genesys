# frozen_string_literal: true

# == Schema Information
#
# Table name: trip_memberships
#
#  id                 :bigint           not null, primary key
#  is_invite_accepted :boolean          default(FALSE)
#  user_display_name  :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  trip_id            :bigint
#  user_id            :bigint
#
# Indexes
#
#  index_trip_memberships_on_trip_id  (trip_id)
#  index_trip_memberships_on_user_id  (user_id)
#
class TripMembership < ApplicationRecord
  belongs_to :trip
  belongs_to :user
  attr_accessor :username

  validate :max_capacity_not_reached

  def max_capacity_not_reached
    if trip.trip_memberships.count >= 20
      errors.add(:base, "The trip has reached the 20 member capacity, please remove a member before adding another.")
    end
  end
end
