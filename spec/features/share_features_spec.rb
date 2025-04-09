# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Sharing Features") do
  let(:app_feature) { create(:app_feature, name: "Feature", description: "Feature Description") }
  let(:subscription_tier) { create(:subscription_tier) }

  before do
    app_feature
    create(:app_features_subscription_tier, app_feature: app_feature, subscription_tier: subscription_tier)
  end

  scenario "I can view a feature" do
    visit root_path

    within(:css, ".features-carousel") do
      expect(page).to(have_content(app_feature.name))
      expect(page).to(have_content(app_feature.description))
    end
  end

  scenario "I can share a feature by email", js: true do
    visit root_path

    click_button "Share"

    # Check link to prevent opening email
    email_link = find("a", text: "Email")
    uri = URI.parse(email_link[:href])
    expect("#{uri.path}?#{uri.query}").to(eq(share_api_feature_path(id: app_feature.id, method: "email")))
  end

  scenario "I can share a feature on Facebook", js: true do
    visit root_path
    click_button "Share"
    expect_to_share_to("https://www.facebook.com/sharer/sharer.php", [ROOT_URL])
    click_link "Facebook"
  end

  scenario "I can share a feature on Twitter", js: true do
    visit root_path
    click_button "Share"
    expect_to_share_to("https://x.com/intent/", [app_feature.name, app_feature.description.downcase])
    click_link "Twitter"
  end

  scenario "I can share a feature on WhatsApp", js: true do
    visit root_path
    click_button "Share"
    expect_to_share_to("https://wa.me/", [app_feature.name, app_feature.description.downcase])
    click_link "WhatsApp"
  end

  feature "Visiting an invalid share route" do
    scenario "I receive a 400 bad request when using an invalid method" do
      visit share_api_feature_path(app_feature, method: "invalid")
      expect(page.status_code).to(eq(400))
    end

    scenario "I receive a 400 bad request when using a feature ID that doesn't exist" do
      visit share_api_feature_path(id: "invalid", method: "email")
      expect(page.status_code).to(eq(400))
    end
  end

  scenario "It increments the engagement count for the feature", js: true, opens_new_tab: true do
    inital_engagement = app_feature.engagement_counter

    visit root_path

    click_button "Share"

    click_link "Twitter"
    page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
    sleep_for_js
    expect(app_feature.reload.engagement_counter).to(eq(inital_engagement + 1))
  end
end
