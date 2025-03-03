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
require "rails_helper"

RSpec.describe(TripMembership, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end
