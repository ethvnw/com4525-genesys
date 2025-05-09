# frozen_string_literal: true

# == Schema Information
#
# Table name: trip_memberships
#
#  id                   :bigint           not null, primary key
#  invite_accepted_date :datetime
#  is_invite_accepted   :boolean          default(FALSE)
#  user_display_name    :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  sender_user_id       :bigint
#  trip_id              :bigint
#  user_id              :bigint
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
  include Countable

  MAX_CAPACITY = 20

  belongs_to :trip, counter_cache: true
  belongs_to :user
  belongs_to :sender_user, class_name: "User", inverse_of: :sent_invites, optional: true
  attr_accessor :username

  after_create :add_counter_cache
  after_update :update_counter_cache
  after_destroy :remove_counter_cache

  validate :max_capacity_not_reached
  validates_length_of :user_display_name, maximum: 30, allow_blank: true
  after_update :nullify_sender_user

  def max_capacity_not_reached
    if trip.trip_memberships_count >= MAX_CAPACITY
      errors.add(
        :base,
        "The trip has reached the #{MAX_CAPACITY} member capacity, please remove a member before adding another.",
      )
    end
  end

  ##
  # Removes sender_user_id when invite is accepted - it's only needed for the inbox, when an invite is not accepted.
  # Means that when users delete their accounts, only unaccepted invites are deleted.
  def nullify_sender_user
    if is_invite_accepted && sender_user.present?
      update_column(:sender_user_id, nil)
    end
  end

  ##
  # Increments the trip's counter cache on creation
  def add_counter_cache
    if is_invite_accepted
      user.increment!(:trips_count)
    end
  end

  ##
  # Decrements the user's trip count when removing from the trip
  def remove_counter_cache
    if is_invite_accepted
      user.decrement!(:trips_count)
    end
  end

  ##
  # Updates the user's trip count when accepting/rejecting the invite
  def update_counter_cache
    if is_invite_accepted_before_last_save != is_invite_accepted
      if is_invite_accepted
        user.increment!(:trips_count)
      else
        user.decrement!(:trips_count)
      end
    end
  end
end
