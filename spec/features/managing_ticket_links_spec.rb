# frozen_string_literal: true

require "rails_helper"
require_relative "../support/helpers/trips_and_plans_helper"

RSpec.feature("Managing ticket links") do
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

  feature "Create a ticket link" do
    scenario "I can add a ticket link and see it on the show page", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      select_location("England")
      select_seperated_date_range(start_date_for_js, end_date_for_js)
      # Attach a ticket link
      click_on "Ticket Links"
      within("#ticket-links-container") do
        fill_in "ticket_link_name", with: "Awesome Ticket"
        fill_in "ticket_link_url", with: "https://roamiotravel.co.uk"
        click_button "Add"
      end
      # Expect new entry to appear in the table dynamically
      within("#ticket-links-container") do
        within("table") do
          expect(page).to(have_content("Awesome Ticket"))
          expect(page).to(have_content("https://roamiotravel.co.uk"))
        end
      end
      click_on "Save"
      await_message("Plan created successfully")
      visit trip_plan_path(trip, trip.plans.first)
      # Expect the ticket link to be a link to the URL with the correct text
      expect(page).to(have_content("Ticket Links"))
      expect(page).to(have_link("Awesome Ticket", href: "https://roamiotravel.co.uk"))
    end

    scenario "If I enter a ticket link with the same name twice, I see an approriate error message", js: true do
      visit new_trip_plan_path(trip)
      click_on "Ticket Links"
      within("#ticket-links-container") do
        fill_in "ticket_link_name", with: "Test Name"
        fill_in "ticket_link_url", with: "https://roamiotravel.co.uk"
        click_button "Add"
        fill_in "ticket_link_name", with: "Test Name"
        fill_in "ticket_link_url", with: "https://example.com"
        click_button "Add"
      end
      expect(page).to(have_content("A ticket link with this name already exists."))
    end

    scenario "If I enter a ticket link with the same URL twice, I see an approriate error message", js: true do
      visit new_trip_plan_path(trip)
      click_on "Ticket Links"
      within("#ticket-links-container") do
        fill_in "ticket_link_name", with: "Test Name"
        fill_in "ticket_link_url", with: "https://roamiotravel.co.uk"
        click_button "Add"
        fill_in "ticket_link_name", with: "Test Name 2"
        fill_in "ticket_link_url", with: "https://roamiotravel.co.uk"
        click_button "Add"
      end
      expect(page).to(have_content("A ticket link with this URL already exists."))
    end

    scenario "If I submit an invalid URL for a ticket link, I see an approriate error message", js: true do
      visit new_trip_plan_path(trip)
      click_on "Ticket Links"
      within("#ticket-links-container") do
        fill_in "ticket_link_name", with: "Test Name"
        fill_in "ticket_link_url", with: "not a url"
        click_button "Add"
      end
      expect(page).to(have_content("Please enter a valid URL (beginning with http:// or https://)."))
    end

    scenario "I cannot add more than 10 ticket links", js: true do
      visit new_trip_plan_path(trip)
      click_on "Ticket Links"
      within("#ticket-links-container") do
        10.times do |i|
          fill_in "ticket_link_name", with: "Test Name #{i}"
          fill_in "ticket_link_url", with: "https://roamiotravel.co.uk/#{i}"
          click_button "Add"
        end
        expect(page).not_to(have_content("You can only add up to 10 ticket links."))
        fill_in "ticket_link_name", with: "Test Name 11"
        fill_in "ticket_link_url", with: "https://roamiotravel.co.uk/11"
        click_button "Add"
        # Expect an error message to be shown
        expect(page).to(have_content("You can only add up to 10 ticket links."))
      end
    end
  end

  feature "Edit a plan with ticket links" do
    let!(:plan) { create(:plan, trip: trip) }
    let(:plan_with_ticket_link) { create(:plan, :with_ticket_link, trip: trip) }

    scenario "I can add a new ticket link and see it on the plan show page", js: true do
      visit edit_trip_plan_path(trip, plan)
      click_on "Ticket Links"
      within "#ticket-links-container" do
        fill_in "ticket_link_name", with: "Awesome Ticket"
        fill_in "ticket_link_url", with: "https://roamiotravel.co.uk"
        click_button "Add"
        expect(page).to(have_content("Awesome Ticket"))
        expect(page).to(have_content("https://roamiotravel.co.uk"))
      end
      click_on "Save"
      await_message("Plan updated successfully")
      visit trip_plan_path(trip, plan)
      # Expect the booking reference text to be present on the plan page
      expect(page).to(have_content("Ticket Links"))
      expect(page).to(have_link("Awesome Ticket", href: "https://roamiotravel.co.uk"))
    end

    scenario "I can remove a ticket link and see it removed on the new page and show page", js: true do
      visit edit_trip_plan_path(trip, plan_with_ticket_link)
      # Remove the booking reference from the plan
      click_on "Ticket Links"
      within "#ticket-links-container" do
        expect(page).to(have_content("Example Ticket"))
        expect(page).to(have_content("https://example.com/ticket"))
        accept_confirm do
          click_on "Delete"
        end
        expect(page).not_to(have_content("Example Ticket"))
        expect(page).not_to(have_content("https://example.com/ticket"))
      end
      click_on "Save"
      await_message("Plan updated successfully")
      # Can no longer access the trip plan page as the booking reference has been removed
      visit trip_plan_path(trip, plan_with_ticket_link)
      expect(page).to(have_content("No tickets available for this plan."))
    end
  end
end
