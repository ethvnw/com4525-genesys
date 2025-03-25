# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing plans") do
  let(:user) { create(:user) }
  let(:trip) { FactoryBot.create(:trip) }

  before do
    login_as(user, scope: :user)
    travel_to(Time.parse("2025-01-10 1:30:00"))
    stub_photon_api
  end

  feature "Creating plans" do
    scenario "I cannot create a plan with no title", js: true do
      visit new_trip_plan_path(trip)
      select "Other", from: "plan_plan_type"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("England")
      find_all(".aa-Item").first.click
      fill_in "plan_start_date", with: Time.current + 1.day
      click_on "Save"
      expect(page).to(have_content("Title can't be blank"))
    end

    scenario "I cannot create a plan with a title that is too long (>250 characters)", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "a" * 300
      select "Other", from: "plan_plan_type"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("England")
      find_all(".aa-Item").first.click
      fill_in "plan_start_date", with: Time.current + 1.day
      click_on "Save"
      expect(page).to(have_content("Title is too long (maximum is 250 characters)"))
    end

    scenario "I cannot create a plan with no provided plan type", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "a"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("England")
      find_all(".aa-Item").first.click
      fill_in "plan_start_date", with: Time.current + 1.day
      click_on "Save"
      expect(page).to(have_content("Plan type is not included in the list"))
    end

    scenario "I cannot create a plan with no start location" do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      fill_in "plan_start_date", with: Time.current + 1.day
      click_on "Save"
      expect(page).to(have_content("Start location name can't be blank"))
    end

    scenario "I cannot create a plan with no start date", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("England")
      find_all(".aa-Item").first.click
      click_on "Save"
      expect(page).to(have_content("Start date can't be blank"))
    end

    scenario "I cannot create a plan with a start date after the end date", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("England")
      find_all(".aa-Item").first.click
      fill_in "plan_start_date", with: Time.current + 2.days
      fill_in "plan_end_date", with: Time.current + 1.day
      click_on "Save"
      expect(page).to(have_content("Start date cannot be after end date"))
    end

    scenario "I cannot create a plan with a start date prior to the current time", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("England")
      find_all(".aa-Item").first.click
      fill_in "plan_start_date", with: Time.current - 1.day
      click_on "Save"
      expect(page).to(have_content("Start date cannot be in the past"))
    end

    scenario "I cannot create a plan with no end location if it is a travel plan", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Travel By Plane", from: "plan_plan_type"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("England")
      find_all(".aa-Item").first.click
      fill_in "plan_start_date", with: Time.current + 1.day
      fill_in "plan_end_date", with: Time.current + 2.days
      click_on "Save"
      expect(page).to(have_content("End location name must be present for travel plans"))
    end

    scenario "I can input an end location if I choose a travel plan", js: true do
      visit new_trip_plan_path(trip)
      select "Travel By Plane", from: "plan_plan_type"
      sleep_for_js
      expect(find("#end-location-autocomplete", visible: :all)).to(be_visible)
    end

    scenario "I can create a plan and see its information on the plans index page", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("England")
      find_all(".aa-Item").first.click
      fill_in "plan_start_date", with: Time.current + 1.day
      click_on "Save"
      visit trip_path(trip)
      expect(page).to(have_content("Test Title"))
      expect(page).to(have_content("Other"))
      expect(page).to(have_content("England"))
      expect(page).to(have_content(Time.current.strftime("%H:%M")))
    end

    scenario "I can create 2 plans within the same day and see their information on the plans index page",
      js: true,
      vcr: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("England")

      find_all(".aa-Item").first.click
      fill_in "Start date", with: Time.current + 1.day
      click_on "Save"
      sleep_for_js
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title 2"
      select "Other", from: "plan_plan_type"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("Brazil")

      find_all(".aa-Item").first.click
      sleep_for_js
      fill_in "Start date", with: Time.current + 1.day + 2.hours
      click_on "Save"

      visit trip_path(trip)
      expect(page).to(have_selector("h4.fw-bold.mb-0.max-height-2-lines", count: 2))
      expect(page).to(have_content("England"))
      expect(page).to(have_content("Brazil"))
    end
  end

  feature "Edit a plan" do
    given!(:plan) { FactoryBot.create(:plan) }

    scenario "I can edit the start location of a plan and see it on the plan page", js: true do
      visit trip_path(plan.trip_id)
      within(:css, "section #plan-settings.dropdown") do
        find("button").click
        click_on "Edit plan"
      end

      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("Brazil")
      find_all(".aa-Item").first.click
      click_on "Save"
      expect(page).not_to(have_content("England"))
    end

    scenario "I can edit the type of plan" do
      visit trip_path(plan.trip_id)
      within(:css, "section #plan-settings.dropdown") do
        find("button").click
        click_on "Edit plan"
      end

      select "Restaurant", from: "plan_plan_type"
      click_on "Save"
      expect(page).to(have_content("Restaurant"))
    end

    scenario "If I edit a plan and remove the title, I see an error message" do
      visit trip_path(plan.trip_id)
      within(:css, "section #plan-settings.dropdown") do
        find("button").click
        click_on "Edit plan"
      end

      fill_in "plan_title", with: ""
      click_on "Save"
      expect(page).to(have_content("Title can't be blank"))
    end

    scenario "If I change the plan type to not a travel plan, the end location is removed", js: true do
      visit trip_path(plan.trip_id)
      within(:css, "section #plan-settings.dropdown") do
        find("button").click
        click_on "Edit plan"
      end

      sleep_for_js
      expect(find("#end-location-autocomplete", visible: :all)).to(be_visible)

      select "Restaurant", from: "plan_plan_type"
      sleep_for_js

      expect(find("#end-location-autocomplete", visible: :all)).not_to(be_visible)
    end
  end

  feature "Delete a plan" do
    given!(:plan) { FactoryBot.create(:plan) }

    scenario "I can delete a plan and see it removed from the plans index page" do
      visit trip_path(plan.trip_id)
      expect(page).to(have_content(plan.start_location_name))
      within(:css, "section #plan-settings.dropdown") do
        find("button").click
        click_on "Delete plan"
      end
      expect(page).not_to(have_content(plan.start_location_name))
    end
  end
end
