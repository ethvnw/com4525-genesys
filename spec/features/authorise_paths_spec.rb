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

RSpec.feature("General Path Authorisation") do
  let!(:admin) { create(:admin) }
  let!(:reporter) { create(:reporter) }

  # Trip and plan for user 1
  let!(:user) { create(:user) }
  let!(:trip) { create(:trip) }
  let!(:trip_membership) { create(:trip_membership, user: user, trip: trip) }
  let!(:plan) { create(:plan, trip: trip) }

  # Trip and plan for user 2
  let!(:user2) { create(:user) }
  let!(:trip2) { create(:trip) }
  let!(:trip_membership2) { create(:trip_membership, user: user2, trip: trip2) }
  let!(:plan2) { create(:plan, trip: trip2) }

  feature "As a user not logged in" do
    [
      ["homepage", let(:path) { home_path }],
      ["inbox page", let(:path) { inbox_path }],
      ["plan form page", let(:path) { new_trip_plan_path(trip) }],
      ["trip form page", let(:path) { new_trip_path }],
      ["trips page", let(:path) { trips_path }],
      ["trip memberships page", let(:path) { trip_trip_memberships_path(trip) }],
      ["editing plan page", let(:path) { edit_trip_plan_path(trip, plan) }],
      ["editing trip page", let(:path) { edit_trip_path(trip) }],
    ].each do |test_desc, _|
      scenario "I am unauthorised to access #{test_desc}" do
        visit path

        # Expect user to be redirected to login path
        expect(page.status_code).to(eq(200))
        expect(page).to(have_current_path(new_user_session_path))

        expect(page).to(have_content("You need to sign in or sign up before continuing."))
      end
    end
  end

  feature "As a member user" do
    before do
      login_as(user, scope: :user)
    end

    scenario "I am authorised to access the homepage" do
      visit home_path
      expect(page.status_code).to(eq(200))
      expect(page).to(have_content("Upcoming Trips"))
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
    [
      ["plan form page", let(:path) { new_trip_plan_path(trip2) }],
      ["trip memberships page", let(:path) { trip_trip_memberships_path(trip2) }],
      ["editing plan page", let(:path) { edit_trip_plan_path(trip2, plan2) }],
      ["editing trip page", let(:path) { edit_trip_path(trip2) }],
    ].each do |test_desc, _|
      scenario "I am not authorised to access #{test_desc} for a trip that I am not part of" do
        visit path
        expect(page.status_code).to(eq(401))
      end
    end
  end

  # Avoid duplicate unit tests for staff users who are unauthorised on member pages
  # https://railsware.com/blog/using-configurable-shared-examples-in-rspec/
  shared_examples "A staff user" do |user_role|
    before do
      login_as(send(user_role), scope: :user)
    end

    scenario "I am authorised to access the landing page" do
      visit root_path
      expect(page.status_code).to(eq(200))
      expect(page).to(have_current_path(root_path))
    end

    [
      ["homepage", let(:path) { home_path }],
      ["inbox page", let(:path) { inbox_path }],
      ["plan form page", let(:path) { new_trip_plan_path(trip) }],
      ["trip form page", let(:path) { new_trip_path }],
      ["trips page", let(:path) { trips_path }],
      ["trip memberships page", let(:path) { trip_trip_memberships_path(trip) }],
      ["editing plan page", let(:path) { edit_trip_plan_path(trip, plan) }],
      ["editing trip page", let(:path) { edit_trip_path(trip) }],
    ].each do |_test_desc, _|
      scenario "I am not authorised to access member pages" do
        visit path

        # Expect user to be redirected to landing page
        expect(page.status_code).to(eq(200))
        expect(page).to(have_current_path(root_path))
        expect(page).to(have_content("Unable to access members-only page as a staff user."))
      end
    end
  end

  feature "As a reporter user" do
    it_behaves_like("A staff user", :reporter)
  end

  feature "As an admin user" do
    it_behaves_like("A staff user", :admin)
  end
end
