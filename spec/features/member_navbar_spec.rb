# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Member navbar") do
  let!(:member) { create(:user, username: "allisoncameron") }

  feature "Member can navigate using the navbar" do
    before do
      login_as(member, scope: :user)
    end

    scenario "Accessing the home page" do
      # Start from trips path
      visit trips_path

      within("#navigation-links") do
        # Check that the trips link is highlighted (current page)
        expect(page).to(have_link("Trips", href: trips_path, class: "active"))

        # Navigate to home using the link
        expect(page).to(have_link("Home", href: home_path))
        click_link "Home"
      end

      # Check current path and page content
      expect(current_path).to(eq(home_path))
      expect(page).to(have_content("Home"))
    end

    scenario "Accessing the create trip page" do
      # Start from home path
      visit home_path

      within("#navigation-links") do
        # Check that the home link is highlighted (current page)
        expect(page).to(have_link("Home", href: home_path, class: "active"))

        # Navigate to create trip using the link
        expect(page).to(have_link("Create Trip", href: new_trip_path))
        click_link "Create Trip"
      end

      # Check current path and page content
      expect(current_path).to(eq(new_trip_path))
      expect(page).to(have_content("Create a New Trip"))
    end

    scenario "Accessing the trips page" do
      # Start from create trip path
      visit new_trip_path

      within("#navigation-links") do
        # Check that the new trip link is highlighted (current page)
        expect(page).to(have_link("Create Trip", href: new_trip_path, class: "active"))

        # Navigate to trips using the link
        expect(page).to(have_link("Trips", href: trips_path))
        click_link "Trips"
      end

      # Check current path and page content
      expect(current_path).to(eq(trips_path))
      expect(page).to(have_content("Trips"))
    end
  end

  # TODO: Ensure correct amount of notifications are displayed for trip invitations
  feature "Invitation notifications amount is displayed" do
  end
end
