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
require "rails_helper"
require_relative "../concerns/countable_shared_examples"

RSpec.describe(TripMembership, type: :model) do
  it_behaves_like "countable"

  describe "#nullify_sender_user" do
    context "when accepting an invite" do
      let(:invite) { create(:trip_membership, is_invite_accepted: false) }

      it "sets sender_user to nil" do
        expect(invite.sender_user).not_to(be_nil)
        invite.update!(is_invite_accepted: true)
        expect(invite.reload.sender_user).to(be_nil)
      end
    end
  end

  describe "#max_capacity_not_reached" do
    let(:trip) { create(:trip) }
    let(:trip_membership) { build(:trip_membership, trip:) }
    let(:capacity_error) do
      "The trip has reached the #{TripMembership::MAX_CAPACITY} member capacity, " \
        "please remove a member before adding another."
    end

    context "when the trip has reached max capacity" do
      before do
        create_list(:trip_membership, TripMembership::MAX_CAPACITY, trip:)
      end

      it "adds an error" do
        expect(trip_membership).not_to(be_valid)
        expect(trip_membership.errors[:base]).to(include(capacity_error))
      end
    end

    context "when the trip has not reached max capacity" do
      it "is valid" do
        expect(trip_membership).to(be_valid)
      end
    end
  end
end
