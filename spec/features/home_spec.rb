# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Viewing Homepage") do
  let(:app_feature) { create(:app_feature, name: "Feature", description: "Feature Description") }
  let(:subscription_tier) { create(:subscription_tier) }

  before do
    app_feature
    create(:app_features_subscription_tier, app_feature: app_feature, subscription_tier: subscription_tier)
  end

  feature "App features" do
    scenario "I can view a feature" do
      visit root_path

      within(:css, ".features-carousel") do
        expect(page).to(have_content(app_feature.name))
        expect(page).to(have_content(app_feature.description))
      end
    end

    scenario "I share a feauture on email", js: true do
      visit root_path

      click_button "Share"

      # Check link to prevent opening email
      email_link = find('a[href^="mailto:"]', text: "Email")
      decoded_email_link = CGI.unescape(email_link[:href])
      expect(decoded_email_link).to(include("mailto:"))
      expect(decoded_email_link).to(include(app_feature.name))
      expect(decoded_email_link).to(include(app_feature.description.downcase))
    end

    scenario "I share a feauture on a Facebook", js: true do
      visit root_path

      click_button "Share"

      click_link "Facebook"

      # Facebook doesn't accept body in sharer, so just check for URL
      expect(current_url).to eq("https://www.facebook.com/sharer/sharer.php?u=roamio.com")
    end

    scenario "I share a feauture on a Twitter", js: true do
      visit root_path

      click_button "Share"

      click_link "Twitter"

      decoded_link = CGI.unescape(current_url)
      expect(decoded_link).to(include("https://x.com/intent/tweet?text="))
      expect(decoded_link).to(include(app_feature.name))
      expect(decoded_link).to(include(app_feature.description.downcase))
    end
  
    scenario "I share a feauture on a WhatsApp", js: true do
      visit root_path

      click_button "Share"

      click_link "WhatsApp"

      decoded_link = CGI.unescape(current_url)
      expect(decoded_link).to(include("https://api.whatsapp.com/send/?text="))
      expect(decoded_link).to(include(app_feature.name))
      expect(decoded_link).to(include(app_feature.description.downcase))
    end
  end
end
