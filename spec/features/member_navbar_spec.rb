# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Member navbar") do
  let!(:member) { create(:user, username: "allisoncameron") }

  before do
    login_as(member, scope: :user)
  end

  feature "Member can navigate using the navbar" do
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

  feature "Invitation notification count" do
    let(:member) { create(:user) }
    let(:accepted_trip) { create(:trip) }
    let(:unaccepted_trip) { create(:trip) }
    let(:unrelated_trip) { create(:trip) }

    context "when there is one pending invite" do
      scenario "shows the correct count" do
        # One accepted invite (should not count)
        create(:trip_membership, user: member, trip: accepted_trip, is_invite_accepted: true)

        # One pending invite (should count)
        create(:trip_membership, user: member, trip: unaccepted_trip, is_invite_accepted: false)

        # Unrelated invite (should not count)
        create(:trip_membership, trip: unrelated_trip, is_invite_accepted: false)

        visit home_path

        within("#account-links") do
          expect(find("a", text: "Inbox")).to(have_content("1"))
        end
      end
    end

    context "when all invites are pending" do
      scenario "shows the correct count" do
        # Two pending invites (should count)
        create(:trip_membership, user: member, trip: accepted_trip, is_invite_accepted: false)
        create(:trip_membership, user: member, trip: unaccepted_trip, is_invite_accepted: false)

        # Unrelated trip (should not count)
        create(:trip_membership, trip: unrelated_trip, is_invite_accepted: false)

        visit home_path

        within("#account-links") do
          expect(find("a", text: "Inbox")).to(have_content("2"))
        end
      end
    end

    context "when there are no invites" do
      scenario "does not show a count" do
        # Unrelated invite (should not count)
        create(:trip_membership, trip: unrelated_trip, is_invite_accepted: false)

        visit home_path

        within("#account-links") do
          expect(find("a", text: "Inbox")).to_not(have_content("0"))
        end
      end
    end
  end
end
