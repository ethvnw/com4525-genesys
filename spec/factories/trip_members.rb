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
