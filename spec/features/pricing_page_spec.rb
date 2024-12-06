# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Pricing page", type: :feature) do
  let(:free_tier) { create(:subscription_tier, name: "Free", price_gbp: 0, engagement_counter: 0) }
  # Explorer is appended to any premium tier, so "Individual" is "Explorer Individual"
  let(:explorer_tier) { create(:subscription_tier, name: "Individual", price_gbp: 10) }

  before do
    free_tier
    explorer_tier
  end

  scenario "I can see prices for different subscription tiers" do
    visit pricing_subscriptions_path

    expect(page).to(have_content("Free"))
    expect(page).to(have_content("Explorer Individual"))
    expect(page).to(have_content("£10"))
  end

  scenario "I can see features for different subscription tiers" do
    # Feature descriptions are not displayed on pricing page
    explorer_feature = build(:app_feature, name: "Explorer Feature", description: nil)
    free_feature = build(:app_feature, name: "Free Feature", description: nil)
    # Associate feature with the tiers
    explorer_tier.app_features << explorer_feature
    free_tier.app_features << free_feature
    visit pricing_subscriptions_path

    within(:css, "##{free_tier.name.downcase}-tier-card") do
      expect(page).to(have_content(free_feature.name))
      expect(page).to_not(have_content(explorer_feature.name))
    end

    within(:css, "##{explorer_tier.name.downcase}-tier-card") do
      expect(page).to_not(have_content(free_feature.name))
      expect(page).to(have_content(explorer_feature.name))
    end
  end

  scenario "I can select the free tier option" do
    visit pricing_subscriptions_path

    click_on "Get #{free_tier.name}"

    expect(page).to(have_current_path(new_subscription_path(s_id: free_tier.id)))
    expect(page).to(have_content("Hello! You've caught us early"))
  end

  scenario "I can select the explorer individual tier option" do
    visit pricing_subscriptions_path

    click_on "Get Explorer #{explorer_tier.name}"

    expect(page).to(have_current_path(new_subscription_path(s_id: explorer_tier.id)))
    expect(page).to(have_content("Hello! You've caught us early"))
  end

  scenario "It increments the engagement counter" do
    inital_engagement = free_tier.engagement_counter

    visit pricing_subscriptions_path

    click_on "Get #{free_tier.name}"

    sleep_for_js
    expect(free_tier.reload.engagement_counter).to(eq(inital_engagement + 1))
  end
end
