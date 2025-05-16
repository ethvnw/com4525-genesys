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
#  index_trip_memberships_on_created_at            (created_at)
#  index_trip_memberships_on_invite_accepted_date  (invite_accepted_date)
#  index_trip_memberships_on_sender_user_id        (sender_user_id)
#  index_trip_memberships_on_trip_id               (trip_id)
#  index_trip_memberships_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (sender_user_id => users.id)
#  fk_rails_...  (trip_id => trips.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :trip_membership do
    is_invite_accepted { true }
    invite_accepted_date { Time.current }
    user_display_name { "Mock Display Name" }

    association :user
    association :trip
    association :sender_user, factory: :user
  end
end
