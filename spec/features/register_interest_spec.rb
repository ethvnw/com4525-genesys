# frozen_string_literal: true

require "rails_helper"
require "registrations_helper"

RSpec.feature("Registering Interest") do
  scenario "I can register my interest" do
    create(:subscription_tier, :individual)
    visit root_path

    click_link "Join the travel revolution"
    click_on "Get Explorer Individual"

    register_with_email

    expect(Registration.find_by(email: "test@example.com")).to(be_present)
    expect(page).to(have_content("Successfully registered"))
  end

  scenario "After I register my interest, my geolocation will be saved" do
    ENV["TEST_IP_ADDR"] = "185.156.172.142" # IP address in Amsterdam

    create(:subscription_tier, :individual)
    visit root_path

    click_link "Join the travel revolution"
    click_on "Get Explorer Individual"

    register_with_email

    expect(Registration.find_by(email: "test@example.com", country_code: "NL")).to(be_present)
    ENV["TEST_IP_ADDR"] = nil
  end

  describe "The landing page journey", js: true do
    let!(:free_tier) { create(:subscription_tier) }
    let!(:individual_tier) { create(:subscription_tier, :individual) }
    let!(:feature) { create(:app_feature) }
    let!(:review1) { create(:review) }
    let!(:review2) { create(:review) }
    let!(:question1) { create(:question) }
    let!(:question2) { create(:question) }

    before do
      create(:app_features_subscription_tier, app_feature: feature, subscription_tier: free_tier)

      visit root_path
    end

    scenario "After registering, my landing page journey will be saved to the database", js: true do
      share_feature(feature, "Facebook")
      share_feature(feature, "WhatsApp")

      click_link "Reviews"
      click_button(id: "review_#{review1.id}")
      click_button(id: "review_#{review2.id}")

      click_link "FAQ"
      click_button(id: "question_#{question1.id}")
      click_button(id: "question_#{question2.id}")

      click_link "Pricing"
      click_link "Get Explorer Individual"

      register_with_email

      # Removing this stops registrations_controller from being able to access the database
      # It is unable to find subscription_tier, leading to a validation error
      # even though subscription_controller can find it
      sleep(1)

      registration = Registration.first

      expect(
        FeatureShare.find_by(app_feature_id: feature.id, registration_id: registration.id, share_method: "facebook"),
      ).to(be_present)
      expect(
        FeatureShare.find_by(app_feature_id: feature.id, registration_id: registration.id, share_method: "whatsapp"),
      ).to(be_present)

      expect(ReviewLike.find_by(review_id: review1.id, registration_id: registration.id)).to(be_present)
      expect(ReviewLike.find_by(review_id: review2.id, registration_id: registration.id)).to(be_present)

      expect(QuestionClick.find_by(question_id: question1.id, registration_id: registration.id)).to(be_present)
      expect(QuestionClick.find_by(question_id: question2.id, registration_id: registration.id)).to(be_present)
    end

    scenario "Duplicate events will not be saved twice", js: true do
      share_feature(feature, "Facebook")
      share_feature(feature, "Facebook")

      # Don't need to check duplicate review events as the second review click will 'unlike' the review

      click_link "FAQ"
      click_button(id: "question_#{question1.id}")
      click_button(id: "question_#{question1.id}")

      click_link "Pricing"
      click_link "Get Explorer Individual"

      register_with_email

      sleep_for_js # Give time for registration request to be processed

      expect(FeatureShare.count).to(eq(1))
      expect(QuestionClick.count).to(eq(1))
    end

    scenario "An unliked review will not appear in my landing page journey", js: true do
      click_link "Reviews"
      click_button(id: "review_#{review1.id}")
      click_button(id: "review_#{review1.id}")

      click_link "Pricing"
      click_link "Get Explorer Individual"

      register_with_email

      sleep_for_js # Give time for registration request to be processed

      expect(FeatureShare.count).to(be_zero)
    end
  end

  context "when email validation fails" do
    scenario "I will be told if the email I entered is blank" do
      tier = create(:subscription_tier)
      visit new_subscription_path(s_id: tier.id)
      click_on "Notify Me"

      expect(page).to(have_content("Email can't be blank"))
    end

    scenario "I will be told if the email I entered is invalid" do
      tier = create(:subscription_tier)
      visit new_subscription_path(s_id: tier.id)
      fill_in "registration_email", with: "invalid_email"
      click_on "Notify Me"

      expect(page).to(have_content("Email is invalid"))
    end

    scenario "I will be told if the email I entered is already taken" do
      create(:registration, email: "test@example.com")
      tier = create(:subscription_tier)
      visit new_subscription_path(s_id: tier.id)
      fill_in "registration_email", with: "test@example.com"
      click_on "Notify Me"

      expect(page).to(have_content("Email has already been taken"))
    end
  end

  context "when visiting the registration route for a tier that does not exist" do
    scenario "I will be redirected to the pricing page" do
      visit new_subscription_path(s_id: 123)
      expect(current_path).to(eq(pricing_subscriptions_path))
    end
  end
end
