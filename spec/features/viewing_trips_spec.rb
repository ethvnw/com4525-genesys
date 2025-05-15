# frozen_string_literal: true

require "rails_helper"
require_relative "../support/helpers/trips_and_plans_helper"
require_relative "../concerns/pageable_shared_examples"

RSpec.feature("Viewing trips") do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
    time_travel_everywhere(Time.zone.parse("2020-01-01 00:00:00"))
  end

  context "When I have no trips" do
    scenario "On the list view" do
      visit trips_path
      click_on "List"
      expect(page).to(have_content("No Trips Created"))
    end

    scenario "On the map view" do
      visit trips_path
      click_on "Map"
      expect(page).to(have_content("No Trips Created"))
    end
  end

  context "When I am a member of trips" do
    let(:trip1) do
      create(
        :trip,
        title: "Mock Trip 1",
        start_date: Time.zone.parse("2020-01-02"),
        end_date: Time.zone.parse("2020-01-16"),
        location_latitude: 50,
        location_longitude: 50,
      )
    end

    let(:trip2) do
      create(
        :trip,
        title: "Mock Trip 2",
        start_date: Time.zone.parse("2020-01-18"),
        end_date: Time.zone.parse("2020-01-20"),
        location_latitude: 25,
        location_longitude: 25,
      )
    end

    let(:collaborative_trip) do
      create(
        :trip,
        title: "Mock Collaborative Trip",
        start_date: Time.zone.parse("2020-01-25"),
        end_date: Time.zone.parse("2020-02-12"),
        location_latitude: -12,
        location_longitude: -12,
      )
    end

    let(:user2) { create(:user, email: "second@example.com", username: "seconduser") }

    before do
      create(:trip_membership, trip: trip1, user: user)
      create(:trip_membership, trip: trip2, user: user)
      create(:trip_membership, trip: collaborative_trip, user: user)
      create(:trip_membership, trip: collaborative_trip, user: user2)
    end

    scenario "Viewing my trips as a list" do
      visit trips_path
      click_on "List"

      expect_to_have_trip_as_list_item(trip1, "2nd - 16th Jan 2020")
      expect_to_have_trip_as_list_item(trip2, "18th - 20th Jan 2020")
      expect_to_have_trip_as_list_item(collaborative_trip, "25th Jan - 12th Feb 2020")

      within("#trips-list-header") do
        expect(page).to(have_content("3 Trips Planned"))
      end

      within("a[href='/trips/#{collaborative_trip.id}']") do |trip_card|
        expect(trip_card).to(have_selector("img[data-bs-title='#{user2.username}']"))
      end
    end

    scenario "Viewing my trips as a map", js: true do
      visit trips_path
      click_on "Map"

      expect_to_have_trip_on_map(trip1)
      expect_to_have_trip_on_map(trip2)
      expect_to_have_trip_on_map(collaborative_trip)
    end
  end

  context "when I have more than 12 trips" do
    before do
      25.times do
        create(:trip_membership, trip: create(:trip), user: user, sender_user: user)
      end

      visit trips_path(view: "list")
    end

    it_behaves_like("responsive pager with infinite scroll", 12, 25)
  end
end
