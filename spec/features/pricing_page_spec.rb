# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Pricing page", type: :feature) do
  before(:each) do
    @free_tier = create(:subscription_tier, name: "Free", price_gbp: 0)
    # Explorer is appended to any premium tier, so "Individual" is "Explorer Individual"
    @explorer_tier = create(:subscription_tier, name: "Individual", price_gbp: 10)
  end

  scenario "I can see prices for different subscription tiers" do
    visit subscription_tiers_pricing_path

    expect(page).to(have_content("Free"))
    expect(page).to(have_content("Explorer Individual"))
    expect(page).to(have_content("£10"))
  end

  scenario "I can see features for different subscription tiers" do
    # Feature descriptions are not displayed on pricing page
    @explorer_feature = create(:app_feature, name: "Explorer Feature", description: nil)
    @free_feature = create(:app_feature, name: "Free Feature", description: nil)
    # Associate feature with the tiers
    @explorer_tier.app_features << @explorer_feature
    @free_tier.app_features << @free_feature
    visit subscription_tiers_pricing_path

    within("##{@free_tier.name.downcase}-tier-card") do
      expect(page).to(have_content(@free_feature.name))
      expect(page).to_not(have_content(@explorer_feature.name))
    end

    within("##{@explorer_tier.name.downcase}-tier-card") do
      expect(page).to_not(have_content(@free_feature.name))
      expect(page).to(have_content(@explorer_feature.name))
    end
  end

  scenario "I can select the free tier option" do
    visit subscription_tiers_pricing_path

    click_on "Get #{@free_tier.name}"

    expect(page).to(have_current_path(subscription_tiers_register_path(s_id: @free_tier.id)))

    expect(page).to(have_content("Hello! You've caught us early"))
  end

  scenario "I can select the explorer individual tier option" do
    visit subscription_tiers_pricing_path

    click_on "Get Explorer #{@explorer_tier.name}"

    expect(page).to(have_current_path(subscription_tiers_register_path(s_id: @explorer_tier.id)))

    expect(page).to(have_content("Hello! You've caught us early"))
  end
end
