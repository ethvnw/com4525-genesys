# frozen_string_literal: true

require "rails_helper"

RSpec.feature("User account dropdown") do
  let!(:admin) { create(:admin, username: "lisacuddy") }
  let!(:reporter) { create(:reporter, username: "gregoryhouse") }
  let!(:member) { create(:user, username: "ericforeman") }

  feature "Admin user dropdown", js: true do
    before do
      login_as(admin, scope: :user)
    end

    scenario "Admin can access admin dashboard through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click
      within("#user-account-dropdown") do
        expect(page).to(have_link("Admin Dashboard", href: admin_dashboard_path))

        click_link "Admin Dashboard"
      end

      expect(page).to(have_content("Admin Dashboard"))
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

    scenario "Admin can access account settings through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click
      within("#user-account-dropdown") do
        expect(page).to(have_link("My Account", href: edit_user_registration_path))
        click_link "My Account"
      end

      expect(page).to(have_content("Personal Details"))
    end

    scenario "Admin can sign out using dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("Sign Out", href: destroy_user_session_path))
        click_link "Sign Out"
      end

      expect(page).to(have_content("Signed out successfully."))
    end

    scenario "Admin can see their username in dropdown" do
      visit root_path

      within("#user-account-dropdown .dropdown-username") do
        expect(page).to(have_content("lisacuddy"))
      end
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

    scenario "Reporter can access reporter dashboard through dropdown" do
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

      expect(page).to(have_content("Personal Details"))
    end

    scenario "Reporter can sign out using dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("Sign Out", href: destroy_user_session_path))
        click_link "Sign Out"
      end

      expect(page).to(have_content("Signed out successfully."))
    end

    scenario "Reporter can see their username in dropdown" do
      visit root_path

      within("#user-account-dropdown .dropdown-username") do
        expect(page).to(have_content("gregoryhouse"))
      end
    end
  end

  feature "Member user dropdown", js: true do
    before do
      login_as(member, scope: :user)
    end

    scenario "Member can't access admin and reporter dashboards through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click
      within("#user-account-dropdown") do
        expect(page).to_not(have_link("Admin Dashboard", href: admin_dashboard_path))
        expect(page).to_not(have_link("Reporter Dashboard", href: reporter_dashboard_path))
      end
    end

    scenario "Member can access account settings through dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("My Account", href: edit_user_registration_path))
        click_link "My Account"
      end

      expect(page).to(have_content("Personal Details"))
    end

    scenario "Member can sign out using dropdown" do
      visit root_path

      find("#user-account-dropdown .dropdown-toggle").click

      within("#user-account-dropdown") do
        expect(page).to(have_link("Sign Out", href: destroy_user_session_path))
        click_link "Sign Out"
      end

      expect(page).to(have_content("Signed out successfully."))
    end

    scenario "Member can see their username in dropdown" do
      visit root_path

      within("#user-account-dropdown .dropdown-username") do
        expect(page).to(have_content("ericforeman"))
      end
    end
  end
end
