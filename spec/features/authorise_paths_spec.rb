# frozen_string_literal: true

##
# These set of tests cover general path access abilities for various roles
# that are not covered by other tests.
#
# Resources are also blocked by abilities, but page access prevention provides
# extra security.
#
# The error code and brief content is checked for clarification as sometimes
# the user is redirected with an error message rather than taking them to 401,
# depending on the scenario.
##

require "rails_helper"
require_relative "../support/helpers/trips_and_plans_helper"

RSpec.feature("General Path Authorisation") do
  let!(:admin) { create(:admin) }
  let!(:reporter) { create(:reporter) }

  # Trip and plan for user 1
  let!(:user) { create(:user) }
  let!(:trip) { create(:trip) }
  let!(:trip_membership) { create(:trip_membership, user: user, trip: trip) }
  given!(:plan) { create(:plan, trip: trip) }

  # Trip and plan for user 2
  let!(:user2) { create(:user) }
  let!(:trip2) { create(:trip) }
  let!(:trip_membership2) { create(:trip_membership, user: user2, trip: trip2) }
  given!(:plan2) { create(:plan, trip: trip2) }

  before do
    trip_membership
    trip_membership2
  end

  feature "As a member user" do
    before do
      login_as(user, scope: :user)
    end

    scenario "I am authorised to access the homepage" do
      visit home_path
      expect(page.status_code).to(eq(200))
      expect(page).to(have_content("My Trips"))
    end

    scenario "I am authorised to access the inbox page" do
      visit inbox_path
      expect(page.status_code).to(eq(200))
      expect(page).to(have_content("Inbox"))
    end

    scenario "I am authorised to access the plan form page" do
      visit new_trip_plan_path(trip)
      expect(page.status_code).to(eq(200))
      expect(page).to(have_content("New plan for Mock Trip"))
    end

    scenario "I am authorised to access the trip form page" do
      visit new_trip_path
      expect(page.status_code).to(eq(200))
      expect(page).to(have_content("Create a New Trip"))
    end

    scenario "I am authorised to access and view all my trips" do
      visit trips_path
      expect(page.status_code).to(eq(200))
      expect(page).to(have_content("Mock Trip"))
    end

    scenario "I am authorised to access and manage trip members" do
      visit trip_trip_memberships_path(trip)
      expect(page.status_code).to(eq(200))
      expect(page).to(have_content("Manage Members"))
    end

    scenario "I am authorised to access and edit a plan I am part of" do
      visit edit_trip_plan_path(trip, plan)
      expect(page.status_code).to(eq(200))
      expect(page).to(have_content("Editing Mock Plan"))
    end

    scenario "I am authorised to access edit a trip I am part of" do
      visit edit_trip_path(trip)
      expect(page.status_code).to(eq(200))
      expect(page).to(have_content("Editing Mock Trip"))
    end

    scenario "I am unable to access the landing page and get redirected to the homepage" do
      visit root_path
      expect(page.status_code).to(eq(200))
      expect(page).to(have_current_path(home_path))
    end

    # User 1 is currently logged in trying to access user 2's plans and trips (which user 1 is not part of)
    scenario "I am not authorised to access trips and plans pages that I am not part of" do
      [
        ["plan form page", -> { new_trip_plan_path(trip2) }],
        ["trip memberships page", -> { trip_trip_memberships_path(trip2) }],
        ["editing plan page", -> { edit_trip_plan_path(trip2, plan2) }],
        ["editing trip page", -> { edit_trip_path(trip2) }],
      ].each do |test_desc, path|
        visit path.call
        expect(page.status_code).to(eq(401), "Error (Status 401): #{test_desc}")
      end
    end
  end

  # Avoid duplicate unit tests for staff users who are unauthorised on member pages
  # https://railsware.com/blog/using-configurable-shared-examples-in-rspec/
  shared_examples "A staff user with unauthorised access" do |user_role|
    before do
      login_as(send(user_role), scope: :user)
    end

    scenario "I am not authorised to access the landing page" do
      visit root_path
      expect(page.status_code).to(eq(200))
      expect(page).to(have_current_path(root_path))
    end

    scenario "I am not authorised to access member pages" do
      [
        ["homepage", -> { home_path }],
        ["inbox page", -> { inbox_path }],
        ["plan form page", -> { new_trip_plan_path(trip) }],
        ["trip form page", -> { new_trip_path }],
        ["trips page", -> { trips_path }],
        ["trip memberships page", -> { trip_trip_memberships_path(trip) }],
        ["editing plan page", -> { edit_trip_plan_path(trip, plan) }],
        ["editing trip page", -> { edit_trip_path(trip) }],
      ].each do |test_desc, path|
        visit path.call
        # Error code 200 as they are re-directed with an error message
        expect(page.status_code).to(eq(200), "Error (Status 200): #{test_desc}")
        expect(page).to(have_current_path(root_path), "Error (Path): #{test_desc}")
        expect(page).to(
          have_content("Unable to access members-only page as a staff user."),
          "Error (Content): #{test_desc}",
        )
      end
    end
  end

  feature "As an admin user" do
    it_behaves_like("A staff user with unauthorised access", :admin)
  end

  feature "As a reporter user" do
    it_behaves_like("A staff user with unauthorised access", :reporter)
  end

  feature "As a user not logged in" do
    scenario "I am not authorised to access signed in pages" do
      [
        ["homepage", -> { home_path }],
        ["inbox page", -> { inbox_path }],
        ["plan form page", -> { new_trip_plan_path(trip) }],
        ["trip form page", -> { new_trip_path }],
        ["trips page", -> { trips_path }],
        ["trip memberships page", -> { trip_trip_memberships_path(trip) }],
        ["editing plan page", -> { edit_trip_plan_path(trip, plan) }],
        ["editing trip page", -> { edit_trip_path(trip) }],
      ].each do |test_desc, path|
        visit path.call
        # Error code 200 as they are re-directed with an error message
        expect(page.status_code).to(eq(200), "Error (Status 200): #{test_desc}")
        expect(page).to(have_current_path(new_user_session_path), "Error (Path): #{test_desc}")
        expect(page).to(
          have_content("You need to sign in or sign up before continuing."),
          "Error (Content): #{test_desc}",
        )
      end
    end
  end
end
