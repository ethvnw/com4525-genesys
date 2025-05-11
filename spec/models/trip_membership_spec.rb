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
end
