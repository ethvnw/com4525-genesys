# frozen_string_literal: true

require "rails_helper"
require_relative "../support/helpers/trips_and_plans_helper"

RSpec.feature("Managing scannable tickets") do
  let(:user) { create(:user) }
  let(:trip) { create(:trip) }
  let(:trip_membership) { create(:trip_membership, user: user, trip: trip) }

  let(:start_time) { Time.current + 1.days }
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
    time_travel_everywhere(Time.current)
    freeze_time
    stub_photon_api
  end

  feature "Create a scannable ticket" do
    scenario "I can add a scannable ticket to a plan and see it on the show page", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      select_location("England")
      select_seperated_date_range(start_date_for_js, end_date_for_js)
      # Attach a QR code file
      click_on "QR Codes"
      attach_file("qr_codes_upload", Rails.root.join("spec", "support", "files", "qr_hello_world.png"))
      expect(page).to(have_content("1 of 1")) # Expect the QR code to be loaded
      click_on "Save"
      expect(page).to(have_content("Plan created successfully"))
      visit trip_plan_path(trip, trip.plans.first)
      # Expect the QR code text to be present on the plan page
      expect(page).to(have_content("Hello World!"))
    end

    scenario "If I add a scannable ticket to an incomplete plan and submit the form, I see an error message",
      js: true do
      visit new_trip_plan_path(trip)
      # Specifically do not fill in any fields
      click_on "Save"
      expect(page).not_to(have_content("Please re-add your documents and/or tickets."))
      # Attach a QR code file
      click_on "QR Codes"
      attach_file("qr_codes_upload", Rails.root.join("spec", "support", "files", "qr_hello_world.png"))
      click_on "Save"
      expect(page).to(have_content("Please re-add your documents and/or tickets."))
    end
  end

  feature "Edit a plan with scannable tickets" do
    let(:plan_with_ticket) { create(:scannable_ticket, plan: create(:plan, trip: trip)).plan }

    scenario "I can add additional scannable tickets to a plan and see them on the plan page", js: true do
      visit trip_plan_path(trip, plan_with_ticket)
      # Expect the QR code text to be present on the plan page
      expect(page).to(have_content("Mock ticket code"))
      expect(page).to(have_content("1 of 1"))
      visit edit_trip_plan_path(trip, plan_with_ticket)
      # Add an new ticket with a different QR code value
      click_on "QR Codes"
      attach_file("qr_codes_upload", Rails.root.join("spec", "support", "files", "qr_hello_world.png"))
      click_on "Save"
      # Expect the "already existed" notice to not be present
      expect(page).not_to(have_content("Some QR codes already existed..."))
      # Expect there to now be two QR codes
      visit trip_plan_path(trip, plan_with_ticket)
      expect(page).to(have_content("1 of 2"))
    end

    scenario "If I try to add an already existing scannable ticket, a notice is shown and it is not added", js: true do
      visit trip_plan_path(trip, plan_with_ticket)
      # Expect the QR code text to be present on the plan page
      expect(page).to(have_content("Mock ticket code"))
      expect(page).to(have_content("1 of 1"))
      visit edit_trip_plan_path(trip, plan_with_ticket)
      # qr_mock.png is a QR code that contains the data "Mock ticket code"
      click_on "QR Codes"
      attach_file("qr_codes_upload", Rails.root.join("spec", "support", "files", "qr_mock.png"))
      click_on "Save"
      # Expect a notice indicating the QR code already exists
      expect(page).to(have_content("Some QR codes already existed..."))
      # Expect there to still only be one QR code
      visit trip_plan_path(trip, plan_with_ticket)
      expect(page).to(have_content("1 of 1"))
    end
  end

  feature "Delete a scannable ticket" do
    let(:plan_with_ticket) { create(:scannable_ticket, plan: create(:plan, trip: trip)).plan }

    scenario "I can delete a scannable and see it removed from the plan" do
      # Check that the ticket is present in the plan
      visit edit_trip_plan_path(trip, plan_with_ticket)
      within("#scannable-tickets-table") do
        expect(page).to(have_content("Mock ticket code"))
      end
      click_on("Remove")
      await_message("Scannable Ticket deleted successfully.")
      # Check that the ticket is removed from the plan
      expect(page).not_to(have_selector("#scannable-tickets-table"))
      expect(page).not_to(have_content("Mock ticket code"))
    end
  end
end
