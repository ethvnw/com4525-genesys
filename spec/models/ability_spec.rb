# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Ability, type: :model) do
  let(:admin_user) { build(:user, user_role: :admin) }
  let(:reporter_user) { build(:user, user_role: :reporter) }
  let(:user) { create(:user) }

  describe "#initialize" do
    context "when the user has admin permissions (authorisation)" do
      let(:ability) { Ability.new(admin_user) }

      it "allows the ability to manage all resources" do
        expect(ability.can?(:manage, :all)).to(be_truthy)
      end

      it "allows access to the admin dashboard" do
        expect(ability.can?(:access, :admin_dashboard)).to(be_truthy)
      end
    end
  end

  context "when the user has reporter permissions (authorisation)" do
    let(:ability) { Ability.new(reporter_user) }

    it "allows the ability to read all resources" do
      expect(ability.can?(:read, :all)).to(be_truthy)
    end

    it "it allows access to the reporter dashboard" do
      expect(ability.can?(:access, :reporter_dashboard)).to(be_truthy)
    end
  end

  context "when the user has no role" do
    let(:ability) { Ability.new(user) }

    it "allows reading public content" do
      expect(ability.can?(:read, :public_content)).to(be_truthy)
    end

    it "does not allow accessing the admin dashboard" do
      expect(ability.can?(:access, :admin_dashboard)).to(be_falsey)
    end

    it "does not allow accessing the reporter dashboard" do
      expect(ability.can?(:access, :reporter_dashboard)).to(be_falsey)
    end
  end
end
