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
  describe "#premium_subscription?" do
    let(:premium_tier) { build(:subscription_tier, price_gbp: 10) }
    let(:free_tier) { build(:subscription_tier, price_gbp: 0) }
    let(:no_subscription_tier) { build(:subscription_tier, price_gbp: nil) }

    it "returns true if price_gbp is greater than 0" do
      expect(premium_tier.premium_subscription?).to(be_truthy)
    end

    it "returns false if price_gbp is 0" do
      expect(free_tier.premium_subscription?).to(be_falsey)
    end

    it "returns false if price_gbp is nil" do
      expect(no_subscription_tier.premium_subscription?).to(be_falsey)
    end
  end
end
