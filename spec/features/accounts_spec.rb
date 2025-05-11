# frozen_string_literal: true

require "rails_helper"

RSpec.feature("User accounts") do
  feature "As a user without an account" do
    scenario "I can access the signup page by selecting the free plan" do
      create(:subscription_tier)

      visit root_path

      click_on "Join the travel revolution"
      click_on "Get Free"

      expect(page).to(have_button("Sign Up"))
      expect(current_path).to(eq(new_user_registration_path))
    end

    scenario "I can sign up for an account using the signup form" do
      visit new_user_registration_path

      fill_in "Email", with: "mocK@email.com"
      fill_in "Username", with: "mockuser1"
      fill_in "Password", with: "MockPassword1"
      fill_in "Password confirmation", with: "MockPassword1"

      click_on "Sign Up"

      await_message("signed up successfully.")
    end
  end
end
