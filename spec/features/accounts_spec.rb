# frozen_string_literal: true

require "rails_helper"

RSpec.feature("User accounts") do
  feature "As a user without an account" do
    scenario "I access the signup page by selecting the free plan" do
      create(:subscription_tier)

      visit root_path

      click_on "Join the travel revolution"
      click_on "Get Free"

      expect(page).to(have_content("Sign Up"))
      expect(current_path).to(eq(new_user_registration_path))
    end

    scenario "I can sign up for an account using the signup form" do
      visit new_user_registration_path

      fill_in "Email", with: "mocK@email.com"
      fill_in "Username", with: "mockuser1"
      fill_in "Password", with: "MockPassword1"
      fill_in "Password confirmation", with: "MockPassword1"

      click_on "Sign Up"
    end

    scenario "Admin can access account settings through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("My Account", href: edit_user_registration_path))
        sleep_for_js
        click_link "My Account"
      end

      expect(page).to(have_content("Edit User"))
    end
  end

  feature "Reporter user dropdown", js: true do
    before do
      login_as(reporter, scope: :user)
    end

    scenario "Reporter can't access admin dashboard through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to_not(have_link("Admin Dashboard", href: admin_dashboard_path))
      end
    end

    scenario "Admin can access reporter dashboard through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("Reporter Dashboard", href: reporter_dashboard_path))

        click_link "Reporter Dashboard"
      end

      expect(page).to(have_content("Reporter Dashboard"))
    end

    scenario "Reporter can access account settings through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("My Account", href: edit_user_registration_path))

        click_link "My Account"
      end

      expect(page).to(have_content("Edit User"))
    end
  end
end
