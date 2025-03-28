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
  end

  feature "As a user with a regular account" do
    let!(:user) { create(:user) }
    before do
      login_as(user, scope: :user)
    end

    scenario "I can access account settings through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("My Account", href: edit_user_registration_path))
      end
    end

    scenario "I cannot access reporter dashboard through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).not_to(have_link("Reporter Dashboard", href: reporter_dashboard_path))
      end
    end

    scenario "I cannot access admin dashboard through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).not_to(have_link("Admin Dashboard", href: admin_dashboard_path))
      end
    end
  end

  feature "As a reporter user", js: true do
    let!(:reporter) { create(:reporter) }
    before do
      login_as(reporter, scope: :user)
    end

    scenario "I can access account settings through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("My Account", href: edit_user_registration_path))
      end
    end

    scenario "I can access reporter dashboard through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("Reporter Dashboard", href: reporter_dashboard_path))
      end
    end

    scenario "I cannot access admin dashboard through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).not_to(have_link("Admin Dashboard", href: admin_dashboard_path))
      end
    end
  end

  feature "As an admin user", js: true do
    let!(:admin) { create(:admin) }
    before do
      login_as(admin, scope: :user)
    end

    scenario "I can access account settings through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("My Account", href: edit_user_registration_path))
      end
    end

    scenario "I can access reporter dashboard through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("Reporter Dashboard", href: reporter_dashboard_path))
      end
    end

    scenario "I can access admin dashboard through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("Admin Dashboard", href: admin_dashboard_path))
      end
    end
  end
end
