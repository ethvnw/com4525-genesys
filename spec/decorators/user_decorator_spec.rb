# frozen_string_literal: true

require "rails_helper"

RSpec.describe(UserDecorator, type: :decorator) do
  let(:user) { create(:user) }
  let(:decorated_user) { user.decorate }

  describe "#user_avatar" do
    context "when id is present" do
      it "it returns an avatar" do
        expect(decorated_user.avatar_url).to(eq("https://api.dicebear.com/9.x/thumbs/svg?seed=#{user.id}"))
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

    context "when no user role is present" do
      before { decorated_user.user_role = nil }
  
      it "correctly formats the role name" do
        expect(decorated_user.show_role).to(eq(""))
      end
    end
  end
end
