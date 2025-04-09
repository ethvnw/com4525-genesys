# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing trips") do
  let(:user) { create(:user) }

  # Mocks the Unsplash::Photo class as API calls cannot happen in tests
  # Unless defined? is used to prevent redefinition of the class
  PhotoMock = Struct.new(:urls) unless defined?(PhotoMock)

  before do
    login_as(user, scope: :user)
    allow(Unsplash::Photo).to(receive(:search).and_return([
      PhotoMock.new({ "regular" => "https://images.unsplash.com/photo-1502602898657-3e91760cbb34" }),
    ]))

    time_travel_everywhere(Time.new(2020, 1, 1, 0, 0, 0, "utc"))
  end

  # Create start and end date variables in yyyy-mm-dd format
  let(:time) { Time.current }
  let(:end_time) { time + 2.day }

  # 0-indexed months are used for js input selection, as js DateTime objects are 0-indexed
  let(:zero_index_month) { format("%02d", time.strftime("%m").to_i - 1) }
  let(:zero_index_end_month) { format("%02d", end_time.strftime("%m").to_i - 1) }

  let(:start_date) { "#{time.year}-#{zero_index_month}-#{format("%02d", time.day)}" }
  let(:end_date) { "#{end_time.year}-#{zero_index_end_month}-#{format("%02d", end_time.day)}" }

  # 1-indexed months are used for display purposes
  let(:start_date_one_index) { time.strftime("%d/%m/%Y") }
  let(:end_date_one_index) { end_time.strftime("%d/%m/%Y") }

  feature "Creating a trip" do
    scenario "I cannot create a trip with no title", js: true do
      visit new_trip_path
      fill_in "trip_description", with: "Mock Trip Description"
      # Fill in the location search field
      select_location("England")
      # Fill in the date range
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_button "Create Trip"
      expect(page).to(have_content("Title can't be blank"))
    end

    scenario "I cannot create a trip with a title longer than the limit (100 characters)", js: true do
      visit new_trip_path
      fill_in "trip_title", with: "a" * 101
      fill_in "trip_description", with: "Mock Trip Description"
      select_location("England")
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_button "Create Trip"
      expect(page).to(have_content("Title is too long (maximum is 100 characters)"))
    end

    scenario "I cannot create a trip with no description", js: true do
      visit new_trip_path
      fill_in "trip_title", with: "Mock Trip Title"
      select_location("England")
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_button "Create Trip"
      expect(page).to(have_content("Description can't be blank"))
    end

    scenario "I cannot create a trip with a description longer than the limit (500 characters)", js: true do
      visit new_trip_path
      fill_in "trip_title", with: "Mock Trip Title"
      fill_in "trip_description", with: "a" * 501
      select_location("England")
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_button "Create Trip"
      expect(page).to(have_content("Description is too long (maximum is 500 characters)"))
    end

    scenario "I cannot create a trip with no date range", js: true do
      visit new_trip_path
      fill_in "trip_title", with: "Mock Trip Title"
      fill_in "trip_description", with: "Mock Trip Description"
      select_location("England")
      click_button "Create Trip"
      expect(page).to(have_content("Date can't be blank"))
    end

    scenario "I cannot create a trip with no location", js: true do
      visit new_trip_path
      fill_in "trip_title", with: "Mock Trip Title"
      fill_in "trip_description", with: "Mock Trip Description"
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_button "Create Trip"
      expect(page).to(have_content("Location can't be blank"))
    end

    scenario "I can create a trip and see it displayed", js: true do
      visit new_trip_path
      fill_in "trip_title", with: "Mock Trip Title"
      fill_in "trip_description", with: "Mock Trip Description"
      select_location("England")
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_button "Create Trip"
      await_message("Trip created successfully")
      # Expect the trip to be displayed on the page, identified by the title
      click_on "Mock Trip Title"
      # The trip details should be displayed, with the title and dates
      expect(page).to(have_content("Mock Trip Title", wait: 5))
      expect(page).to(have_content("01 - 03 Jan 2020"))
    end

    scenario "When I make an error during creation, the data I entered is preserved", js: true do
      # Fill in the form with the required fields
      visit new_trip_path
      fill_in "trip_title", with: "a" * 101 # Title too long error
      fill_in "trip_description", with: "Mock Trip Description"
      select_location("England")
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_button "Create Trip"
      # Expect the form to be displayed with the title and description fields filled in
      expect(page).to(have_field("trip_title", with: "a" * 101))
      expect(page).to(have_field("trip_description", with: "Mock Trip Description"))
      within ".aa-DetachedSearchButtonQuery" do
        expect(page).to(have_content("England"))
      end
      # Then, the values for the start and end date are formatted and compared to the datetimepicker button.
      # During testing, the time is set to 00:00.
      datetime_button = find("#datetimepicker-input")[:value]
      expect(datetime_button).to(have_content("#{start_date_one_index} - #{end_date_one_index}"))
      # The error message should be displayed
      expect(page).to(have_content("Title is too long (maximum is 100 characters)"))
    end

    scenario "When I revisit the trip creation page, previously-submitted information is preserved",
      js: true do
      # Fill in the form with the required fields
      visit new_trip_path
      fill_in "trip_title", with: "a" * 101 # Title too long error
      fill_in "trip_description", with: "Mock Trip Description"
      select_location("England")
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_button "Create Trip"
      expect(page).to(have_content("Looks Good!"))

      visit root_path
      visit new_trip_path

      # Expect the form to be displayed with the title and description fields filled in
      expect(page).to(have_field("trip_title", with: "a" * 101))
      expect(page).to(have_field("trip_description", with: "Mock Trip Description"))
      within ".aa-DetachedSearchButtonQuery" do
        expect(page).to(have_content("England"))
      end
      # Then, the values for the start and end date are formatted and compared to the datetimepicker button.
      # During testing, the time is set to 00:00.
      datetime_button = find("#datetimepicker-input")[:value]
      expect(datetime_button).to(have_content("#{start_date_one_index} - #{end_date_one_index}"))
    end
  end

  feature "Editing a trip" do
    given!(:trip) { create(:trip, start_date: time, end_date: end_time) }
    given!(:trip_membership) { create(:trip_membership, user: user, trip: trip) }

    scenario "I can edit a trip and the existing values will be displayed in the edit form", js: true do
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
      expect(datetime_button).to(have_content("#{start_date_one_index} - #{end_date_one_index}"))
    end

    scenario "I can edit a trip and see the changes displayed", js: true do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Edit Trip"
      fill_in "trip_title", with: "edited title"
      fill_in "trip_description", with: "edited description"
      click_button "Create Trip"
      await_message("Trip updated successfully")
      # Trip title and description should be updated to the edited values
      expect(page).not_to(have_content(trip.title))
      expect(page).to(have_content("edited title"))
    end

    scenario "I cannot edit a trip and save it having removed required fields", js: true do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Edit Trip"
      fill_in "trip_title", with: ""
      click_button "Create Trip"
      expect(page).to(have_content("Title can't be blank"))
    end
  end

  feature "Deleting a trip" do
    given!(:trip) { create(:trip) }
    given!(:trip_membership) { create(:trip_membership, user: user, trip: trip) }

    scenario "I can delete a trip and no longer see it on my list of trips" do
      visit trip_path(trip)
      expect(page).to(have_content(trip.title))
      click_on "Settings"
      click_on "Delete Trip"
      await_message("Trip deleted successfully")
      expect(page).not_to(have_content(trip.title))
    end
  end
end
