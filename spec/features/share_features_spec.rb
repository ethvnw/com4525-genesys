# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Sharing Features") do
  let(:app_feature) { create(:app_feature, name: "Feature", description: "Feature Description") }
  let(:subscription_tier) { create(:subscription_tier) }

  before do
    app_feature
    create(:app_features_subscription_tier, app_feature: app_feature, subscription_tier: subscription_tier)
  end

  # Switch back to original tab after each test (sharing tests require a new tab)
  after(opens_new_tab: true) do
    page.driver.browser.switch_to.window(page.driver.browser.window_handles.first)
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

  scenario "I can share a feature on Facebook", js: true, opens_new_tab: true do
    visit root_path

    click_button "Share"

    click_link "Facebook"

    # Switch to new tab to check share URL
    page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
    expect(page).to(have_current_path("https://www.facebook.com/sharer/sharer.php?u=roamio.com"))
  end

  scenario "I can share a feature on Twitter", js: true, opens_new_tab: true do
    visit root_path

    click_button "Share"

    click_link "Twitter"

    # Switch to new tab to check share URL
    page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
    decoded_link = CGI.unescape(current_url)
    expect(decoded_link).to(include("https://x.com/intent/"))
    expect(decoded_link).to(include(app_feature.name))
    expect(decoded_link).to(include(app_feature.description.downcase))
  end

  scenario "I can share a feature on WhatsApp", js: true, opens_new_tab: true do
    visit root_path

    click_button "Share"

    click_link "WhatsApp"

    # Switch to new tab to check share URL
    page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
    decoded_link = CGI.unescape(current_url)
    expect(decoded_link).to(include("https://api.whatsapp.com/send/?text="))
    expect(decoded_link).to(include(app_feature.name))
    expect(decoded_link).to(include(app_feature.description.downcase))
  end

  scenario "I receive a 400 bad request when I visit the share route with an invalid method" do
    visit share_api_feature_path(app_feature, method: "invalid")
    expect(page.status_code).to(eq(400))
  end

  scenario "I receive a 400 bad request when I visit the share route with an feature ID that doesn't exist" do
    visit share_api_feature_path(id: "invalid", method: "email")
    expect(page.status_code).to(eq(400))
  end
end
