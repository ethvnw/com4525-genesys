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

    it "it does not allow access to the admin dashboard" do
      expect(ability.can?(:access, :admin_dashboard_path)).to(be_falsey)
    end

    it "it allows access to the reporter dashboard" do
      expect(ability.can?(:access, :reporter_dashboard)).to(be_truthy)
    end

    it "it allows the reporter to read registrations" do
      expect(ability.can?(:read, Registration)).to(be_truthy)
    end
  end

  context "when the user has no role" do
    let(:ability) { Ability.new(user) }

    it "does not allow accessing the admin dashboard" do
      expect(ability.can?(:access, :admin_dashboard)).to(be_falsey)
    end

    it "does not allow accessing the reporter dashboard" do
      expect(ability.can?(:access, :reporter_dashboard)).to(be_falsey)
    end

    it "can read subscription tiers" do
      expect(ability.can?(:read, SubscriptionTier)).to(be_truthy)
    end

    it "can read non-hidden questions" do
      question = Question.new(is_hidden: false)
      expect(ability.can?(:read, question)).to(be_truthy)
    end

    it "cannot read hidden questions" do
      question = Question.new(is_hidden: true)
      expect(ability.can?(:read, question)).to(be_falsey)
    end

    it "can read non-hidden reviews" do
      review = Review.new(is_hidden: false)
      expect(ability.can?(:read, review)).to(be_truthy)
    end

    it "cannot read hidden reviews" do
      review = Review.new(is_hidden: true)
      expect(ability.can?(:read, review)).to(be_falsey)
    end
  end
end
