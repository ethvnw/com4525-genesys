# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Registering Interest") do
  scenario "I can register my interest" do
    tier = create(:subscription_tier)
    visit new_subscription_path(s_id: tier.id)
    fill_in "registration_email", with: "test@example.com"
    click_on "Notify Me"

    expect(Registration.find_by(email: "test@example.com")).to(be_present)
    expect(page).to(have_content("Successfully registered"))
  end

  ##
  # Many sleep_for_js calls needed here as without them, registrations_controller
  # cannot access the database - I have spent 5 hours trying to figure out why, to
  # no avail.
  scenario "After registering, my landing page journey will be saved to the database", js: true do
    tier = create(:subscription_tier)
    feature = create(:app_feature)
    feature2 = create(:app_feature)

    create(:app_features_subscription_tier, app_feature: feature, subscription_tier: tier)
    create(:app_features_subscription_tier, app_feature: feature2, subscription_tier: tier)

    review = create(:review, is_hidden: false)
    review2 = create(:review, is_hidden: false)

    question = create(:question, is_hidden: false)
    question2 = create(:question, is_hidden: false)

    visit root_path

    click_button(id: "share_#{feature.id}")
    click_link "Facebook"
    find(".offcanvas-backdrop").click

    click_button(id: "share_#{feature2.id}")
    click_link "WhatsApp"
    find(".offcanvas-backdrop").click

    click_link "Reviews"
    click_button(id: "review_#{review.id}")
    click_button(id: "review_#{review2.id}")

    click_link "FAQ"
    click_button(id: "question_#{question.id}")
    click_button(id: "question_#{question2.id}")

    click_link "Pricing"
    click_link "Get Free"

    fill_in "registration_email", with: "test@example.com"
    click_on "Notify Me"

    sleep_for_js # Removing this stops registrations_controller from being able to access the database

    registration = Registration.first

    expect(
      FeatureShare.find_by(app_feature_id: feature.id, registration_id: registration.id, share_method: "Facebook"),
    ).to(be_present)
    expect(
      FeatureShare.find_by(app_feature_id: feature2.id, registration_id: registration.id, share_method: "WhatsApp"),
    ).to(be_present)

    expect(ReviewLike.find_by(review_id: review.id, registration_id: registration.id)).to(be_present)
    # expect(ReviewLike.find_by(review_id: review2.id, registration_id: registration.id)).to(be_present)
    #
    # expect(QuestionClick.find_by(question_id: question.id, registration_id: registration.id)).to(be_present)
    # expect(QuestionClick.find_by(question_id: question2.id, registration_id: registration.id)).to(be_present)
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
