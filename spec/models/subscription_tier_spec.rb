# frozen_string_literal: true

# == Schema Information
#
# Table name: subscription_tiers
#
#  id                   :bigint           not null, primary key
#  discount_description :string
#  engagement_counter   :integer          default(0), not null
#  name                 :string
#  price_gbp            :decimal(, )
#  terms_description    :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require "rails_helper"

RSpec.describe(SubscriptionTier, type: :model) do
  let!(:premium_tier) { create(:subscription_tier, name: "Premium", price_gbp: 10, engagement_counter: 5) }
  let!(:group_tier) { create(:subscription_tier, name: "Group", price_gbp: 12, engagement_counter: 20) }
  let!(:free_tier) { create(:subscription_tier, name: "Free", price_gbp: 0, engagement_counter: 10) }

  describe ".engagement_stats" do
    it "returns subscription tiers ordered by engagement_counter in descending order" do
      engagement_stats = SubscriptionTier.engagement_stats
      expect(engagement_stats).to(eq([[group_tier.name, 20], [free_tier.name, 10], [premium_tier.name, 5]]))
    end
  end

  describe "#increment_engagement_counter!" do
    let!(:engagement_tier) { create(:subscription_tier, engagement_counter: 0) }

    it "increments the engagement counter by 1" do
      expect { engagement_tier.increment_engagement_counter! }.to(change { engagement_tier.engagement_counter }.by(1))
    end
  end

  describe "#premium_subscription?" do
    let(:no_subscription_tier) { build(:subscription_tier, price_gbp: nil) }

    context "when price_gbp is greater than 0" do
      it "returns true" do
        expect(premium_tier.premium_subscription?).to(be_truthy)
      end
    end

    context "when price_gbp is 0" do
      it "returns false" do
        expect(free_tier.premium_subscription?).to(be_falsey)
      end
    end

    context "when price_gbp is nil" do
      it "returns false" do
        expect(no_subscription_tier.premium_subscription?).to(be_falsey)
      end
    end
  end
end
