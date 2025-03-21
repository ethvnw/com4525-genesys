# frozen_string_literal: true

require "rails_helper"
require "webmock/rspec"

RSpec.feature("Managing trips") do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  # Mocks the Unsplash::Photo class as API calls cannot happen in tests
  # Unless defined? is used to prevent redefinition of the class
  PhotoMock = Struct.new(:urls) unless defined?(PhotoMock)

  before do
    allow(Unsplash::Photo).to(receive(:search).and_return([
      PhotoMock.new({ "regular" => "https://images.unsplash.com/photo-1502602898657-3e91760cbb34" }),
    ]))
  end

  # Create start and end date variables in yyyy-mm-dd format
  let(:zero_index_month) { format("%02d", Time.current.strftime("%m").to_i - 1) }
  let(:start_date) { "#{Time.current.year}-#{zero_index_month}-#{format("%02d", Time.current.day)}" }
  let(:end_date) { "#{Time.current.year}-#{zero_index_month}-#{format("%02d", Time.current.day + 1)}" }
  let(:start_date_one_index) { "#{Time.current.year}-#{Time.current.month}-#{format("%02d", Time.current.day)}" }
  let(:end_date_one_index) { "#{Time.current.year}-#{Time.current.month}-#{format("%02d", Time.current.day + 1)}" }

  feature "Creating a trip" do
    scenario "I cannot create a trip with no title", js: true, vcr: true do
      visit new_trip_path
      fill_in "trip_description", with: "description of plan"
      # Fill in the location search field
      find(".aa-DetachedSearchButton", wait: 3).click
      find(".aa-Input", wait: 3).set("England")
      sleep 3
      find_all(".aa-Item").first.click
      # Fill in the date range
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_on "Create Trip"
      expect(page).to(have_content("Title can't be blank"))
    end

    scenario "I cannot create a trip with a title longer than the limit (100 characters)", js: true, vcr: true do
      visit new_trip_path
      fill_in "trip_title", with: "a" * 101
      fill_in "trip_description", with: "description of plan"
      find(".aa-DetachedSearchButton", wait: 3).click
      find(".aa-Input", wait: 3).set("England")
      sleep 3
      find_all(".aa-Item").first.click
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_on "Create Trip"
      expect(page).to(have_content("Title is too long (maximum is 100 characters)"))
    end

    scenario "I cannot create a trip with no description", js: true, vcr: true do
      visit new_trip_path
      fill_in "trip_title", with: "title of plan"
      find(".aa-DetachedSearchButton", wait: 3).click
      find(".aa-Input", wait: 3).set("England")
      sleep 3
      find_all(".aa-Item").first.click
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_on "Create Trip"
      expect(page).to(have_content("Description can't be blank"))
    end

    scenario "I cannot create a trip with a description longer than the limit (500 characters)", js: true, vcr: true do
      visit new_trip_path
      fill_in "trip_title", with: "title of plan"
      fill_in "trip_description", with: "a" * 501
      find(".aa-DetachedSearchButton", wait: 3).click
      find(".aa-Input", wait: 3).set("England")
      sleep 3
      find_all(".aa-Item").first.click
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_on "Create Trip"
      expect(page).to(have_content("Description is too long (maximum is 500 characters)"))
    end

    scenario "I cannot create a trip with no date range", js: true, vcr: true do
      visit new_trip_path
      fill_in "trip_title", with: "title of plan"
      fill_in "trip_description", with: "description of plan"
      find(".aa-DetachedSearchButton", wait: 3).click
      find(".aa-Input", wait: 3).set("England")
      sleep 3
      find_all(".aa-Item").first.click
      click_on "Create Trip"
      expect(page).to(have_content("Date range can't be blank"))
    end

    scenario "I cannot create a trip with no location", js: true, vcr: true do
      visit new_trip_path
      fill_in "trip_title", with: "title of plan"
      fill_in "trip_description", with: "description of plan"
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_on "Create Trip"
      expect(page).to(have_content("Location can't be blank"))
    end

    scenario "I can create a trip and see it displayed", js: true, vcr: true do
      visit new_trip_path
      fill_in "trip_title", with: "title of plan"
      fill_in "trip_description", with: "description of plan"
      find(".aa-DetachedSearchButton", wait: 3).click
      find(".aa-Input", wait: 3).set("England")
      sleep 3
      find_all(".aa-Item").first.click
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_on "Create Trip"
      # Expect the trip to be displayed on the page, identified by the title
      click_on "title of plan"
      # The trip details should be displayed, with the title and description
      expect(page).to(have_content("title of plan"))
      expect(page).to(have_content("description of plan"))
    end

    scenario "When I make an error during creation, the data I entered is preserved", js: true, vcr: true do
      # Fill in the form with the required fields
      visit new_trip_path
      fill_in "trip_title", with: "a" * 101 # Title too long error
      fill_in "trip_description", with: "description of plan"
      find(".aa-DetachedSearchButton", wait: 3).click
      find(".aa-Input", wait: 3).set("England")
      sleep 3
      find_all(".aa-Item").first.click
      find("#datetimepicker-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_on "Create Trip"
      # Expect the form to be displayed with the title and description fields filled in
      expect(page).to(have_field("trip_title", with: "a" * 101))
      expect(page).to(have_field("trip_description", with: "description of plan"))
      within ".aa-DetachedSearchButtonQuery" do
        expect(page).to(have_content("England"))
      end
      # Then, the values for the start and end date are formatted and compared to the datetimepicker button.
      # The button uses one-index months, so those months are referenced.
      datetime_button = find("#datetimepicker-input")[:value]
      expect(datetime_button).to(have_content(Time.parse(start_date_one_index).strftime("%d/%m/%Y")))
      expect(datetime_button).to(have_content(Time.parse(end_date_one_index).strftime("%d/%m/%Y")))
      # The error message should be displayed
      expect(page).to(have_content("Title is too long (maximum is 100 characters)"))
    end
  end

  feature "Editing a trip" do
    given!(:trip) { FactoryBot.create(:trip) }

    scenario "I can edit a trip and the existing values will be displayed in the edit form", js: true, vcr: true do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Edit trip"
      expect(page).to(have_content("Editing #{trip.title}"))
      expect(page).to(have_field("trip_title", with: trip.title))
      expect(page).to(have_field("trip_description", with: trip.description))
      # .aa-DetachedSearchButtonQuery is the location autocomplete field
      within ".aa-DetachedSearchButtonQuery" do
        expect(page).to(have_content(trip.location_name))
      end
      # Datetimepicker-input is the date range button, expect it to have "start_date - end_date"
      # Multiple variables are assigned to keep within rubocop line limits.
      datetime_button = find("#datetimepicker-input")[:value]
      formatted_start_date = trip.start_date.strftime("%d/%m/%Y %-H:%-M")
      formatted_end_date = trip.end_date.strftime("%d/%m/%Y %-H:%-M")
      datetime_value = "#{formatted_start_date} - #{formatted_end_date}"
      expect(datetime_button).to(eq(datetime_value))
    end

    scenario "I can edit a trip and see the changes displayed", js: true, vcr: true do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Edit trip"
      expect(page).to(have_content("Editing #{trip.title}"))
      fill_in "trip_title", with: "edited title"
      fill_in "trip_description", with: "edited description"
      click_on "Create Trip"
      # Trip title and description should be updated to the edited values
      expect(page).not_to(have_content(trip.title))
      expect(page).to(have_content("edited title"))
      expect(page).not_to(have_content(trip.description))
      expect(page).to(have_content("edited description"))
      click_on "Settings"
      click_on "Edit trip"
      # With these changes carrying over to the edit form
      expect(page).not_to(have_content("Editing #{trip.title}"))
      expect(page).to(have_content("Editing edited title"))
      expect(page).to(have_field("trip_title", with: "edited title"))
      expect(page).to(have_field("trip_description", with: "edited description"))
    end

    scenario "I cannot edit a trip and save it having removed required fields", js: true, vcr: true do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Edit trip"
      fill_in "trip_title", with: ""
      click_on "Create Trip"
      expect(page).to(have_content("Title can't be blank"))
    end
  end

  feature "Deleting a trip" do
    given!(:trip) { FactoryBot.create(:trip) }

    scenario "I can delete a trip and no longer see it on my list of trips" do
      visit trip_path(trip)
      expect(page).to(have_content(trip.title))
      click_on "Settings"
      click_on "Delete trip"
      expect(page).not_to(have_content(trip.title))
    end
  end
end
