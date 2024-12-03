# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Registering Interest") do
  scenario "I can register my interest" do
    tier = create(:subscription_tier)
    visit subscription_tiers_register_path(s_id: tier.id)
    fill_in "registration_email", with: "test@example.com"
    click_on "Notify Me"

    expect(Registration.find_by(email: "test@example.com")).to(be_present)
    expect(page).to(have_content("Successfully registered"))
  end

  context "when email validation fails" do
    scenario "I will be told if the email I entered is blank" do
      tier = create(:subscription_tier)
      visit subscription_tiers_register_path(s_id: tier.id)
      click_on "Notify Me"

      expect(page).to(have_content("Email can't be blank"))
    end

    scenario "I will be told if the email I entered is invalid" do
      tier = create(:subscription_tier)
      visit subscription_tiers_register_path(s_id: tier.id)
      fill_in "registration_email", with: "invalid_email"
      click_on "Notify Me"

      expect(page).to(have_content("Email is invalid"))
    end

    scenario "I will be told if the email I entered is already taken" do
      create(:registration, email: "test@example.com")
      tier = create(:subscription_tier)
      visit subscription_tiers_register_path(s_id: tier.id)
      fill_in "registration_email", with: "test@example.com"
      click_on "Notify Me"

      expect(page).to(have_content("Email has already been taken"))
    end
  end

  context "when visiting the registration route for a tier that does not exist" do
    scenario "I will be redirected to the pricing page" do
      visit subscription_tiers_register_path(s_id: 123)
      expect(current_path).to(eq(subscription_tiers_pricing_path))
    end
  end
end
