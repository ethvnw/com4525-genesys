# frozen_string_literal: true

require "rails_helper"
require_relative "../support/helpers/trips_and_plans_helper"

RSpec.feature("Managing trips") do
  let(:user) { create(:user) }

  let(:start_time) { Time.current }
  let(:end_time) { start_time + 2.days }

  # Create timestamps with 0-indexed months for use in the JS datepicker
  let(:start_date_for_js) do
    "#{start_time.year}-#{format("%02d", start_time.month - 1)}-#{format("%02d", start_time.day)}"
  end
  let(:end_date_for_js) do
    "#{end_time.year}-#{format("%02d", end_time.month - 1)}-#{format("%02d", end_time.day)}"
  end

  # Timestamps that will be displayed
  let(:display_start_date) { start_time.strftime("%d/%m/%Y") }
  let(:display_end_date) { end_time.strftime("%d/%m/%Y") }

  # Mocks the Unsplash::Photo class as API calls cannot happen in tests
  # Unless defined? is used to prevent redefinition of the class
  PhotoMock = Struct.new(:urls) unless defined?(PhotoMock)

  before do
    login_as(user, scope: :user)
    allow(Unsplash::Photo).to(receive(:search).and_return([
      PhotoMock.new({ "regular" => "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?h=108&w=192" }),
    ]))

    time_travel_everywhere(Time.zone.parse("2020-01-01 00:00:00"))
  end

  context "When creating a trip" do
    scenario "With no title", js: true do
      visit new_trip_path
      fill_in "trip_description", with: "Mock Trip Description"
      # Fill in the location search field
      select_location("England")
      # Fill in the date range
      select_date_range(start_date_for_js, end_date_for_js)
      click_button "Save Trip"
      expect(page).to(have_content("Title can't be blank"))
    end

    scenario "I cannot type in a trip title that is too long (>100 characters)", js: true do
      visit new_trip_path
      fill_in "trip_title", with: "a" * 101
      expect(find("#trip_title").value).to(have_content("a" * 100))
    end

    scenario "With a title longer than the limit (100 characters)", js: true do
      visit new_trip_path
      page.execute_script("document.getElementById('trip_title').value = #{("a" * 101).to_json}")
      fill_in "trip_description", with: "Mock Trip Description"
      select_location("England")
      select_date_range(start_date_for_js, end_date_for_js)
      click_button "Save Trip"
      expect(page).to(have_content("Title is too long (maximum is 100 characters)"))
    end

    scenario "I cannot type in a trip description that is too long (>500 characters)", js: true do
      visit new_trip_path
      fill_in "trip_description", with: "a" * 501
      expect(find("#trip_description").value).to(have_content("a" * 500))
    end

    scenario "With no description", js: true do
      visit new_trip_path
      fill_in "trip_title", with: "Mock Trip Title"
      select_location("England")
      select_date_range(start_date_for_js, end_date_for_js)
      click_button "Save Trip"
      expect(page).to(have_content("Description can't be blank"))
    end

    scenario "With a description longer than the limit (500 characters)", js: true do
      visit new_trip_path
      fill_in "trip_title", with: "Mock Trip Title"
      page.execute_script("document.getElementById('trip_description').value = #{("a" * 501).to_json}")
      select_location("England")
      select_date_range(start_date_for_js, end_date_for_js)
      click_button "Save Trip"
      expect(page).to(have_content("Description is too long (maximum is 500 characters)"))
    end

    scenario "With no date range", js: true do
      visit new_trip_path
      fill_in "trip_title", with: "Mock Trip Title"
      fill_in "trip_description", with: "Mock Trip Description"
      select_location("England")
      click_button "Save Trip"
      expect(page).to(have_content("Date can't be blank"))
    end

    scenario "With no location", js: true do
      visit new_trip_path
      fill_in "trip_title", with: "Mock Trip Title"
      fill_in "trip_description", with: "Mock Trip Description"
      select_date_range(start_date_for_js, end_date_for_js)
      click_button "Save Trip"
      expect(page).to(have_content("Location can't be blank"))
    end

    scenario "With valid information", js: true do
      visit new_trip_path
      fill_in "trip_title", with: "Mock Trip Title"
      fill_in "trip_description", with: "Mock Trip Description"
      select_location("England")
      select_date_range(start_date_for_js, end_date_for_js)
      click_button "Save Trip"
      await_message("Trip created successfully")
      # Expect the trip to be displayed on the page, identified by the title
      click_on "Mock Trip Title"
      # The trip details should be displayed, with the title and dates
      expect(page).to(have_content("Mock Trip Title", wait: 5))
      expect(page).to(have_content("01 - 03 Jan 2020"))
    end

    scenario "With valid information and a custom image", js: true do
      visit new_trip_path
      fill_in "trip_title", with: "Mock Trip Title"
      fill_in "trip_description", with: "Mock Trip Description"
      select_location("England")
      select_date_range(start_date_for_js, end_date_for_js)
      # Remove the d-none class so the file input becomes visible, as it is hidden by js by default
      page.execute_script("document.getElementById('image-input').classList.remove('d-none')")
      attach_file("trip[image]", Rails.root.join("spec", "support", "files", "edit_trip_image.jpg"))
      click_button "Save Trip"
      await_message("Trip created successfully")
      # Expect the trip to be displayed on the page, identified by the title
      click_on "Mock Trip Title"
      # The trip details should be displayed, with the title and dates
      expect(page).to(have_content("Mock Trip Title", wait: 5))
      expect(page).to(have_content("01 - 03 Jan 2020"))
      # Expect the right file to be attached
      expect(Trip.first.image.filename.to_s).to(eq("edit_trip_image.jpg"))
    end

    scenario "Preserving data on error", js: true do
      # Fill in the form with the required fields
      visit new_trip_path
      page.execute_script("document.getElementById('trip_title').value = #{("a" * 101).to_json}") # Title too long
      fill_in "trip_description", with: "Mock Trip Description"
      select_location("England")
      select_date_range(start_date_for_js, end_date_for_js)
      click_button "Save Trip"

      # Expect the form to be displayed with the title and description fields filled in
      expect(page).to(have_field("trip_title", with: "a" * 101))
      expect(page).to(have_field("trip_description", with: "Mock Trip Description"))
      within ".aa-DetachedSearchButtonQuery" do
        expect(page).to(have_content("England"))
      end
      # Then, the values for the start and end date are formatted and compared to the datetimepicker button.
      # During testing, the time is set to 00:00.
      datetime_button = find("#datetimepicker-input")[:value]
      expect(datetime_button).to(have_content("#{display_start_date} - #{display_end_date}"))
      # The error message should be displayed
      expect(page).to(have_content("Title is too long (maximum is 100 characters)"))
    end
  end

  context "When Editing a trip" do
    let!(:trip) { create(:trip, start_date: start_time, end_date: end_time) }
    let!(:trip_membership) { create(:trip_membership, user: user, trip: trip) }

    scenario "Displaying current trip information", js: true do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Edit Trip"
      expect(page).to(have_content("Editing #{trip.title}"))
      expect(page).to(have_field("trip_title", with: trip.title))
      expect(page).to(have_field("trip_description", with: trip.description))
      # .aa-DetachedSearchButtonQuery is the location autocomplete field
      within ".aa-DetachedSearchButtonQuery" do
        expect(page).to(have_content(trip.location_name))
      end
      # Datetimepicker-input is the date range button, expect it to have "start_date - end_date"
      datetime_button = find("#datetimepicker-input")[:value]
      expect(datetime_button).to(have_content("#{display_start_date} - #{display_end_date}"))
    end

    scenario "With valid information", js: true do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Edit Trip"
      fill_in "trip_title", with: "edited title"
      fill_in "trip_description", with: "edited description"
      click_button "Save Trip"
      await_message("Trip updated successfully")
      # Trip title and description should be updated to the edited values
      expect(page).not_to(have_content(trip.title))
      expect(page).to(have_content("edited title"))
    end

    scenario "And removing required fields", js: true do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Edit Trip"
      fill_in "trip_title", with: ""
      click_button "Save Trip"
      expect(page).to(have_content("Title can't be blank"))
    end

    scenario "I can upload a trip image when editing a trip and see it attached" do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Edit Trip"
      attach_file("trip[image]", Rails.root.join("spec", "support", "files", "edit_trip_image.jpg"))
      click_button "Save Trip"
      expect(page).to(have_content("Trip updated successfully."))
      expect(trip.reload.image.filename.to_s).to(eq("edit_trip_image.jpg"))
    end
  end

  context "When Deleting a trip" do
    let!(:trip) { create(:trip) }
    let!(:trip_membership) { create(:trip_membership, user: user, trip: trip) }

    scenario "Successfully deleting a trip" do
      visit trip_path(trip)
      expect(page).to(have_content(trip.title))
      click_on "Settings"
      click_on "Delete Trip"
      await_message("Trip deleted successfully")
      expect(page).not_to(have_content(trip.title))
    end
  end

  context "When viewing trips" do
    let!(:trip) { create(:trip) }
    let!(:trip_membership) { create(:trip_membership, user: user, trip: trip) }
    let!(:trip_later) do
      create(
        :trip,
        title: "Later Trip",
        start_date: Time.current + 3.days,
        end_date: Time.current + 4.days,
      )
    end
    let!(:trip_membership_later) { create(:trip_membership, user: user, trip: trip_later) }

    scenario "If I click 'Desc' to sort trips, the order in which trips are displayed is changed", js: true do
      visit trips_path
      expect(page.first(".trip-card")).to(have_content("Mock Trip"))
      click_on "Desc"
      expect(page).to(have_content("Asc"))
      expect(page.first(".trip-card")).to(have_content("Later Trip"))
    end
  end
end
