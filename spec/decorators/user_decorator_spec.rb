# frozen_string_literal: true

require "rails_helper"

RSpec.describe(UserDecorator, type: :decorator) do
  let(:user) { create(:user) }
  let(:decorated_user) { user.decorate }

  describe "#avatar_or_default" do
    context "when the user has an avatar attached" do
      it "returns the avatar attached to the user" do
        # Mock user should already have an avatar attached
        expect(decorated_user.avatar_or_default).to(be_an_instance_of(ActiveStorage::Attached::One))
        expect(user.avatar.filename.to_s).to(eq("mock_avatar.png"))
      end
    end

    context "when the user does not have an avatar attached" do
      before do
        user.avatar.purge
      end

      it "returns the default avatar URL" do
        expect(decorated_user.avatar_or_default).to(eq("api/avatars/#{user.id}"))
      end
    end
  end

  describe "#user_avatar" do
    context "when id is present" do
      it "it returns an avatar" do
        expect(decorated_user.avatar_url).to(eq("api/avatars#{user.id}"))
      end
    end

    context "when no id is present" do
      before { decorated_user.id = nil }

      it "it returns a fallback" do
        expect(decorated_user.avatar_url).to(eq("images/fallback_avatar.png"))
      end
    end
  end

  describe "#show_role" do
    context "when the user is an admin" do
      before { decorated_user.user_role = :admin }

      it "correctly formats the role name" do
        expect(decorated_user.show_role).to(eq("Admin"))
      end
    end

    context "when the user is a reporter" do
      before { decorated_user.user_role = :reporter }

      it "correctly formats the role name" do
        expect(decorated_user.show_role).to(eq("Reporter"))
      end
    end

    context "when the user is a member" do
      before { decorated_user.user_role = :member }

      it "correctly formats the role name" do
        expect(decorated_user.show_role).to(eq("Member"))
      end
    end

    context "when no user role is present" do
      before { decorated_user.user_role = nil }

      it "correctly formats the role name" do
        expect(decorated_user.show_role).to(eq(""))
      end
    end
  end
end
