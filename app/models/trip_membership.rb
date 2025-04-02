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
#  sender_user_id     :bigint
#  trip_id            :bigint
#  user_id            :bigint
#
# Indexes
#
#  index_trip_memberships_on_sender_user_id  (sender_user_id)
#  index_trip_memberships_on_trip_id         (trip_id)
#  index_trip_memberships_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (sender_user_id => users.id)
#
class TripMembership < ApplicationRecord
  MAX_CAPACITY = 20

  belongs_to :trip
  belongs_to :user
  belongs_to :sender_user, class_name: "User"
  attr_accessor :username

  validate :max_capacity_not_reached

  def max_capacity_not_reached
    if trip.trip_memberships.count >= MAX_CAPACITY
      errors.add(
        :base,
        "The trip has reached the #{MAX_CAPACITY} member capacity, please remove a member before adding another.",
      )
    end
  end
end
