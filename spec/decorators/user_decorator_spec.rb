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
        expect(decorated_user.avatar_url).to(eq("/images/fallback_avatar.png"))
      end
    end
  end
end
