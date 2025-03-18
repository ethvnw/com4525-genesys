# frozen_string_literal: true

require "rails_helper"
require "webmock/rspec"

RSpec.feature("Managing trips") do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  # Create start and end date variables in yyyy-mm-dd format
  let(:zero_index_month) { format("%02d", Time.current.strftime("%m").to_i - 1) }
  let(:start_date) { "#{Time.current.year}-#{zero_index_month}-#{format("%02d", Time.current.day)}" }
  let(:end_date) { "#{Time.current.year}-#{zero_index_month}-#{format("%02d", Time.current.day + 1)}" }

  feature "Creating a trip" do
    scenario "I cannot create a trip with no title", js: true, vcr: true do
      visit new_trip_path
      fill_in "trip_description", with: "description of plan"
      find(".aa-DetachedSearchButton", wait: 3).click
      find(".aa-Input", wait: 3).set("England")
      sleep 3
      find_all(".aa-Item").first.click
      find("#datetimepicker1-input").click
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
      find("#datetimepicker1-input").click
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
      find("#datetimepicker1-input").click
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
      find("#datetimepicker1-input").click
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
      find("#datetimepicker1-input").click
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
      find("#datetimepicker1-input").click
      find("div[data-value='#{start_date}']").click
      find("div[data-value='#{end_date}']").click
      click_on "Create Trip"
      expect(page).to(have_content("title of plan"))
      expect(page).to(have_content("description of plan"))
    end
  end
end
