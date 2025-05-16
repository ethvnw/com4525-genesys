# frozen_string_literal: true

require "rails_helper"

RSpec.describe(TripMembershipDecorator, type: :decorator) do
  let(:sender_user) { create(:user) }
  let(:current_user) { create(:user) }
  let(:trip_membership) { create(:trip_membership, sender_user: sender_user, user: current_user) }
  let(:decorated_trip_membership) { trip_membership.decorate }

  describe "#button_text" do
    context "when the trip membership is not accepted" do
      before { trip_membership.update(is_invite_accepted: false) }

      it "returns 'Cancel'" do
        expect(decorated_trip_membership.button_text(sender_user)).to(eq("Cancel"))
      end
    end

    context "when the trip membership is accepted" do
      before { trip_membership.update(is_invite_accepted: true) }

      context "When the invited user is the current user" do
        it "returns 'Leave'" do
          expect(decorated_trip_membership.button_text(current_user)).to(eq("Leave"))
        end
      end

      context "When the invited user is not the current user" do
        it "returns 'Remove'" do
          expect(decorated_trip_membership.button_text(sender_user)).to(eq("Remove"))
        end
      end
    end
  end

  describe "#invitation_date_text" do
    context "when the trip membership is accepted" do
      it "returns the invite accepted date" do
        expect(decorated_trip_membership.invitation_date_text).to(eq(
          "Joined on #{trip_membership.invite_accepted_date.strftime("%d %b %Y")}",
        ))
      end
    end

    context "when the trip membership is not accepted" do
      before { trip_membership.update(is_invite_accepted: false) }

      it "returns the invitation date" do
        expect(decorated_trip_membership.invitation_date_text).to(eq(
          "Invited on #{trip_membership.created_at.strftime("%d %b %Y")}",
        ))
      end
    end
  end
end
