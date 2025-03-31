# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

def they_can(action, resource)
  it { is_expected.to(be_able_to(action, resource)) }
end

def they_cannot(action, resource)
  it { is_expected.not_to(be_able_to(action, resource)) }
end

RSpec.describe(Ability, type: :model) do
  subject(:ability) { Ability.new(user) }

  describe "#initialize" do
    context "when the user has admin permissions" do
      let(:user) { create(:user, :admin) }

      they_can(:manage, :all)
    end

    context "when the user has reporter permissions" do
      let(:user) { create(:user, :reporter) }

      they_cannot(:manage, :all)

      they_can(:access, :landing)
      they_can(:access, :faq)
      they_can(:access, :subscription)
      they_can(:access, :reporter_dashboard)
      they_cannot(:access, :admin_dashboard)

      they_can(:read, Registration.new)
      they_can(:read, SubscriptionTier.new)
      they_can(:read, Question.new(is_hidden: false))
      they_cannot(:read, Question.new(is_hidden: true))
      they_can(:read, Review.new(is_hidden: false))
      they_cannot(:read, Review.new(is_hidden: true))
    end

    context "when the user is a regular member" do
      let(:user) { create(:user) }

      they_cannot(:manage, :all)

      they_cannot(:access, :landing)
      they_cannot(:access, :faq)
      they_cannot(:access, :subscription)
      they_cannot(:access, :reporter_dashboard)
      they_cannot(:access, :admin_dashboard)

      they_cannot(:read, Registration.new)
      they_can(:read, SubscriptionTier.new)
      they_can(:read, Question.new(is_hidden: false))
      they_cannot(:read, Question.new(is_hidden: true))
      they_can(:read, Review.new(is_hidden: false))
      they_cannot(:read, Review.new(is_hidden: true))
    end

    context "when the user is not logged in" do
      let(:user) { nil }

      they_cannot(:manage, :all)

      they_can(:access, :landing)
      they_can(:access, :faq)
      they_can(:access, :subscription)
      they_cannot(:access, :reporter_dashboard)
      they_cannot(:access, :admin_dashboard)

      they_cannot(:read, Registration.new)
      they_can(:read, SubscriptionTier.new)
      they_can(:read, Question.new(is_hidden: false))
      they_cannot(:read, Question.new(is_hidden: true))
      they_can(:read, Review.new(is_hidden: false))
      they_cannot(:read, Review.new(is_hidden: true))
    end
  end
end
