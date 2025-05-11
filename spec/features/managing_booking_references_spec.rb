# frozen_string_literal: true

require "rails_helper"
require_relative "../support/helpers/trips_and_plans_helper"

RSpec.feature("Managing booking references") do
  let(:user) { create(:user) }
  let(:trip) { create(:trip) }
  let(:trip_membership) { create(:trip_membership, user: user, trip: trip) }

  let(:start_time) { Time.current }
  let(:end_time) { start_time + 2.days }

  # Create timestamps with 0-indexed months for use in the JS datepicker
  let(:start_date_for_js) do
    "#{start_time.year}-#{format("%02d", start_time.month - 1)}-#{format("%02d", start_time.day)}"
  end
  let(:end_date_for_js) do
    "#{end_time.year}-#{format("%02d", end_time.month - 1)}-#{format("%02d", end_time.day)}"
  end

  before do
    trip_membership # Prevent lazy evaluation
    login_as(user, scope: :user)
    # Time travel and stubbing the API is dont for creating plans
    time_travel_everywhere(Time.zone.parse("2020-01-01 00:00:00"))
    freeze_time
    stub_photon_api
  end

  feature "Create a booking reference" do
    scenario "I can add a booking reference and see it on the show page", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      select_location("England")
      select_seperated_date_range(start_date_for_js, end_date_for_js)
      # Attach a booking reference
      click_on "Booking References"
      within("#booking-references-container") do
        fill_in "booking_reference_name", with: "Test Name"
        fill_in "booking_reference_number", with: "123456"
        click_button "Add"
      end
      # Expect new entry to appear in the table dynamically
      within("#booking-references-container") do
        within("table") do
          expect(page).to(have_content("Test Name"))
          expect(page).to(have_content("123456"))
        end
      end
      click_on "Save"
      await_message("Plan created successfully")
      visit trip_plan_path(trip, trip.plans.first)
      # Expect the booking reference text to be present on the plan page
      expect(page).to(have_content("Booking References"))
      expect(page).to(have_content("Test Name"))
      expect(page).to(have_content("123456"))
    end

    scenario "If I enter a booking reference with the same name twice, I see an error message", js: true do
      visit new_trip_plan_path(trip)
      click_on "Booking References"
      within("#booking-references-container") do
        fill_in "booking_reference_name", with: "Test Name"
        fill_in "booking_reference_number", with: "123456"
        click_button "Add"
        fill_in "booking_reference_name", with: "Test Name"
        fill_in "booking_reference_number", with: "654321"
        click_button "Add"
      end
      expect(page).to(have_content("A booking reference with this name already exists."))
    end

    scenario "If I enter a booking reference with the same reference number twice, I see an error message", js: true do
      visit new_trip_plan_path(trip)
      click_on "Booking References"
      within("#booking-references-container") do
        fill_in "booking_reference_name", with: "Test Name"
        fill_in "booking_reference_number", with: "123456"
        click_button "Add"
        fill_in "booking_reference_name", with: "Test Name 2"
        fill_in "booking_reference_number", with: "123456"
        click_button "Add"
      end
      expect(page).to(have_content("A booking reference with this reference number already exists."))
    end

    scenario "I cannot add more than 10 booking references", js: true do
      visit new_trip_plan_path(trip)
      click_on "Booking References"
      within("#booking-references-container") do
        10.times do |i|
          fill_in "booking_reference_name", with: "Test Name #{i}"
          fill_in "booking_reference_number", with: "#{i}123456"
          click_button "Add"
        end

        expect(page).not_to(have_content("You can only add up to 10 booking references."))
        fill_in "booking_reference_name", with: "Test Name 11"
        fill_in "booking_reference_number", with: "111123456"
        click_button "Add"
        # Expect an error message to be shown
        expect(page).to(have_content("You can only add up to 10 booking references."))
      end
    end
  end

  feature "Edit a plan with booking references" do
    let!(:plan) { create(:plan, trip: trip) }
    let(:plan_with_booking_reference) { create(:plan, :with_booking_reference, trip: trip) }

    scenario "I can add a new booking reference and see it on the plan show page", js: true do
      visit edit_trip_plan_path(trip, plan)
      click_on "Booking References"
      within "#booking-references-container" do
        fill_in "booking_reference_name", with: "Test Name"
        fill_in "booking_reference_number", with: "123456"
        click_button "Add"
        expect(page).to(have_content("Test Name"))
        expect(page).to(have_content("123456"))
      end
      click_on "Save"
      await_message("Plan updated successfully")
      visit trip_plan_path(trip, plan)
      # Expect the booking reference text to be present on the plan page
      expect(page).to(have_content("Booking References"))
      expect(page).to(have_content("Test Name"))
      expect(page).to(have_content("123456"))
    end

    scenario "I can remove a booking reference and see it removed on the new page and show page", js: true do
      visit edit_trip_plan_path(trip, plan_with_booking_reference)
      # Remove the booking reference from the plan
      click_on "Booking References"
      within "#booking-references-container" do
        expect(page).to(have_content("Booking Reference"))
        expect(page).to(have_content("123"))
        accept_confirm do
          click_on "Delete"
        end
        expect(page).not_to(have_content("Booking Reference"))
        expect(page).not_to(have_content("123"))
      end
      click_on "Save"
      await_message("Plan updated successfully")
      # Can no longer access the trip plan page as the booking reference has been removed
      visit trip_plan_path(trip, plan_with_booking_reference)
      expect(page).to(have_content("No tickets available for this plan."))
    end
  end
end
