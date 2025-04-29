# frozen_string_literal: true

require "rails_helper"

RSpec.feature("User account dropdown") do
  feature "As a user with a regular account" do
    let!(:user) { create(:user) }
    before do
      login_as(user, scope: :user)
    end

    scenario "I can sign out using the dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("Sign Out", href: destroy_user_session_path))
        click_link "Sign Out"
      end

      expect(page).to(have_content("Signed out successfully."))
    end

    scenario "I can see my username in the dropdown" do
      visit root_path

      within("#user-account-dropdown .dropdown-username") do
        expect(page).to(have_content(user.username))
      end
    end

    scenario "I can access my account settings through the dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("My Account", href: edit_user_registration_path))
      end
    end

    scenario "I cannot access the reporter dashboard through the dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).not_to(have_link("Landing Page Analytics", href: analytics_landing_page_path))
        expect(page).not_to(have_link("Trip Analytics", href: analytics_trips_path))
      end
    end

    scenario "I cannot access the admin dashboard through the dropdown" do
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

    scenario "I can sign out using the dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("Sign Out", href: destroy_user_session_path))
        click_link "Sign Out"
      end

      expect(page).to(have_content("Signed out successfully."))
    end

    scenario "I can see my username in the dropdown" do
      visit root_path

      within("#user-account-dropdown .dropdown-username") do
        expect(page).to(have_content(reporter.username))
      end
    end

    scenario "I can access account settings through the dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("My Account", href: edit_user_registration_path))
      end
    end

    scenario "I can access reporter dashboard through the dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("Landing Page Analytics", href: analytics_landing_page_path))
        expect(page).to(have_link("Trip Analytics", href: analytics_trips_path))
      end
    end

    scenario "I cannot access admin dashboard through the dropdown" do
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

    scenario "I can sign out using the dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("Sign Out", href: destroy_user_session_path))
        click_link "Sign Out"
      end

      expect(page).to(have_content("Signed out successfully."))
    end

    scenario "I can see my username in the dropdown" do
      visit root_path

      within("#user-account-dropdown .dropdown-username") do
        expect(page).to(have_content(admin.username))
      end
    end

    scenario "I can access account settings through the dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("My Account", href: edit_user_registration_path))
      end
    end

    scenario "I can access reporter dashboard through the dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("Landing Page Analytics", href: analytics_landing_page_path))
        expect(page).to(have_link("Trip Analytics", href: analytics_trips_path))
      end
    end

    scenario "I can access admin dashboard through the dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("Admin Dashboard", href: admin_dashboard_path))
      end
    end
  end
end
