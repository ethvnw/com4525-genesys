# frozen_string_literal: true

require "rails_helper"

RSpec.feature("User account dropdown") do
  let!(:admin) { create(:admin) }
  let!(:reporter) { create(:reporter) }

  feature "Admin user dropdown", js: true do
    before do
      login_as(admin, scope: :user)
    end

    scenario "Admin can access admin dashboard through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click
      sleep_for_js

      within("#user-account-dropdown") do
        expect(page).to(have_link("Admin Dashboard", href: admin_dashboard_path))

        click_link "Admin Dashboard"
      end

      expect(page).to(have_content("Admin Dashboard"))
    end

    scenario "Admin can access reporter dashboard through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click
      sleep_for_js

      within("#user-account-dropdown") do
        expect(page).to(have_link("Reporter Dashboard", href: reporter_dashboard_path))

        click_link "Reporter Dashboard"
      end

      expect(page).to(have_content("Reporter Dashboard"))
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
