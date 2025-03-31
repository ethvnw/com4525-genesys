# frozen_string_literal: true

require "rails_helper"

RSpec.describe(SubscriptionTierDecorator, type: :decorator) do
  let(:subscription_tier) { create(:subscription_tier, name: "Individual") }
  let(:decorated_tier) { subscription_tier.decorate }

  describe "#formatted_price" do
    context "when price_gbp is nil" do
      before { subscription_tier.price_gbp = nil }

      it "returns an empty string" do
        expect(decorated_tier.formatted_price).to(eq(""))
      end
    end

    context "when price_gbp is 0" do
      before { subscription_tier.price_gbp = 0 }

      it "returns an empty string" do
        expect(decorated_tier.formatted_price).to(eq(""))
      end
    end

    context "when price_gbp is a whole number above 0" do
      before { subscription_tier.price_gbp = 10 }

      it "returns the formatted price without decimals" do
        expect(decorated_tier.formatted_price).to(eq("£10/month"))
      end
    end

    context "when price_gbp has decimal points" do
      context "with 2 decimal places" do
        before { subscription_tier.price_gbp = 9.99 }

        it "returns the formatted price with 2 decimal places" do
          expect(decorated_tier.formatted_price).to(eq("£9.99/month"))
        end
      end

      context "with 1 decimal place" do
        before { subscription_tier.price_gbp = 9.5 }

        it "returns the formatted price padded to 2 decimal places" do
          expect(decorated_tier.formatted_price).to(eq("£9.50/month"))
        end
      end
    end
  end

  describe "#formatted_cta" do
    context "when subscription tier is premium" do
      before do
        allow(subscription_tier).to(receive(:premium_subscription?).and_return(true))
      end

      it "returns the correct call to action" do
        expect(decorated_tier.formatted_cta).to(eq("Get Explorer #{subscription_tier.name}"))
      end
    end

    context "when subscription tier is not premium" do
      before do
        allow(subscription_tier).to(receive(:premium_subscription?).and_return(false))
      end

      it 'returns the correct call to action without "Explorer"' do
        expect(decorated_tier.formatted_cta).to(eq("Get #{subscription_tier.name}"))
      end
    end
  end
end
