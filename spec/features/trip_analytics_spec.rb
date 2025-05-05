# frozen_string_literal: true

require "rails_helper"
require "active_support/testing/time_helpers"
require_relative "../support/helpers/collaborative_trips_helper"

RSpec.feature("Trip Analytics") do
  let(:reporter) { create(:reporter) }
  before do
    login_as(reporter, scope: :user)
    # Wednesday, 10th January 2024 (Week 2)
    travel_to Time.zone.parse("2024-01-10")
  end

  feature "Tracking the number of trips being created", js: true do
    context "When no trips have been created" do
      before do
        visit analytics_trips_path
      end

      scenario "Viewing analytics for today" do
        click_on "Day"
        expect(page).to(have_content("Trips Created\n0\nToday"))
        expect(page).to(have_content("Plans Created\n0\nToday"))
        expect(page).to(have_content("Invitations Sent\n0\nToday"))
      end

      scenario "Viewing analytics for this week" do
        click_on "Week"
        expect(page).to(have_content("Trips Created\n0\nThis Week"))
        expect(page).to(have_content("Plans Created\n0\nThis Week"))
        expect(page).to(have_content("Invitations Sent\n0\nThis Week"))
      end

      scenario "Viewing analytics for this month" do
        click_on "Month"
        expect(page).to(have_content("Trips Created\n0\nThis Month"))
        expect(page).to(have_content("Plans Created\n0\nThis Month"))
        expect(page).to(have_content("Invitations Sent\n0\nThis Month"))
      end

      scenario "Viewing analytics for all time" do
        click_on "All Time"
        expect(page).to(have_content("Trips Created\n0\nAll Time"))
        expect(page).to(have_content("Plans Created\n0\nAll Time"))
        expect(page).to(have_content("Invitations Sent\n0\nAll Time"))
      end
    end

    context "When trips have been created" do
      before do
        trip = create(:trip, created_at: Time.zone.parse("2023-12-12"))
        create(:trip, created_at: Time.zone.parse("2023-12-31"))
        create(:trip, created_at: Time.zone.parse("2024-01-01"))
        create(:trip, created_at: Time.zone.parse("2024-01-07"))
        create(:trip, created_at: Time.zone.parse("2024-01-08"))
        create(:trip, created_at: Time.zone.parse("2024-01-10"))

        create(:plan, trip: trip, created_at: Time.zone.parse("2023-12-12"))
        create(:plan, trip: trip, created_at: Time.zone.parse("2024-01-01"))
        create(:plan, trip: trip, created_at: Time.zone.parse("2024-01-08"))
        create(:plan, trip: trip, created_at: Time.zone.parse("2024-01-10"))

        user = create(:user)
        invite_new_user_to_trip(user, trip, Time.zone.parse("2023-12-30"))
        invite_new_user_to_trip(user, trip, Time.zone.parse("2023-12-31"))
        invite_new_user_to_trip(user, trip, Time.zone.parse("2024-01-01"))
        invite_new_user_to_trip(user, trip, Time.zone.parse("2024-01-02"))
        invite_new_user_to_trip(user, trip, Time.zone.parse("2024-01-03"))
        invite_new_user_to_trip(user, trip, Time.zone.parse("2024-01-08"))
        invite_new_user_to_trip(user, trip, Time.zone.parse("2024-01-09"))
        invite_new_user_to_trip(user, trip, Time.zone.parse("2024-01-10"))
        invite_new_user_to_trip(user, trip, Time.zone.parse("2024-01-10"))

        visit analytics_trips_path
      end

      scenario "Viewing analytics for today" do
        click_on "Day"
        expect(page).to(have_content("Trips Created\n1\nToday"))
        expect(page).to(have_content("Plans Created\n1\nToday"))
        expect(page).to(have_content("Invitations Sent\n2\nToday"))
      end

      scenario "Viewing analytics for this week" do
        click_on "Week"
        expect(page).to(have_content("Trips Created\n2\nThis Week"))
        expect(page).to(have_content("Plans Created\n2\nThis Week"))
        expect(page).to(have_content("Invitations Sent\n4\nThis Week"))
      end

      scenario "Viewing analytics for this month" do
        click_on "Month"
        expect(page).to(have_content("Trips Created\n4\nThis Month"))
        expect(page).to(have_content("Plans Created\n3\nThis Month"))
        expect(page).to(have_content("Invitations Sent\n7\nThis Month"))
      end

      scenario "Viewing analytics for all time" do
        click_on "All Time"
        expect(page).to(have_content("Trips Created\n6\nAll Time"))
        expect(page).to(have_content("Plans Created\n4\nAll Time"))
        expect(page).to(have_content("Invitations Sent\n9\nAll Time"))
      end
    end
  end
end
