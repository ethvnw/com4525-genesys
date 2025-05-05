# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Member home") do
  let!(:member) { create(:user, username: "robertchase") }

  before do
    login_as(member, scope: :user)
  end

  feature "Member can view upcoming trips", js: true do
    let!(:trip_1) { create(:trip, title: "Trip 1", start_date: 3.days.from_now, end_date: 5.days.from_now) }
    let!(:trip_2) { create(:trip, title: "Trip 2", start_date: 1.day.from_now, end_date: 7.days.from_now) }
    let!(:trip_3) { create(:trip, title: "Trip 3", start_date: 2.days.from_now, end_date: 6.days.from_now) }

    scenario "Trips are displayed in order of start date" do
      create(:trip_membership, user: member, trip: trip_1, is_invite_accepted: true)
      create(:trip_membership, user: member, trip: trip_2, is_invite_accepted: true)
      create(:trip_membership, user: member, trip: trip_3, is_invite_accepted: true)

      visit home_path

      # Get the trip titles in the displayed order in the carousel
      within(".latest-trips-carousel") do
        trip_titles = all(".trip-title").map(&:text)
        # View\n is part of the accessibility screen reader
        expect(trip_titles).to(eq(["View\nTrip 2", "View\nTrip 3", "View\nTrip 1"]))
      end
    end

    scenario "When there are no trips, a message is displayed directing to create a trip" do
      visit home_path

      # Find the no trip card in the carousel
      within(".latest-trips-carousel") do
        # Check the link for the card
        find(".no-trips-card", text: "Create your first trip").click
        expect(current_path).to(eq(new_trip_path))
      end
    end
  end

  feature "Member can use quick links" do
    scenario "Quick link to Create Trip" do
      visit home_path

      find(".quick-link-btn", text: "Create Trip").click
      expect(current_path).to(eq(new_trip_path))
    end

    scenario "Quick link to Trips" do
      visit home_path

      find(".quick-link-btn", text: "Trips").click
      expect(current_path).to(eq(trips_path))
    end

    # TODO: Add trip map route
    scenario "Quick link to Trip Map" do
    end
  end

  feature "Member can use featured locations", js: true do
    let!(:featured_location) { create(:featured_location).decorate }

    scenario "Add trip from a featured location" do
      visit home_path

      # Find the featured locations carousel
      within(".featured-locations-carousel") do
        # Navigate to the trip page
        find(".featured-location-card", text: featured_location.name).click
      end

      # Check if on trip page
      expect(current_path).to(eq(new_trip_path))

      # Check the form contents
      expect(page).to(have_field("trip_title", with: featured_location.trip_name))
      # .aa-DetachedSearchButtonQuery is the location autocomplete field
      within ".aa-DetachedSearchButtonQuery" do
        expect(page).to(have_content(featured_location.location_name))
      end
    end
  end
end
