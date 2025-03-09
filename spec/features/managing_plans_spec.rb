# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing plans") do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  feature "Creating plans" do
    scenario "I cannot create a plan with no title" do
      visit new_plan_path
      select "Other", from: "plan_plan_type"
      fill_in "plan_start_location_name", with: "England"
      fill_in "plan_start_date", with: Time.current + 1.day
      click_on "Save"
      expect(page).to(have_content("Title can't be blank"))
    end

    scenario "I cannot create a plan with a title that is too long (>250 characters)" do
      visit new_plan_path
      fill_in "plan_title", with: "a" * 401
      select "Other", from: "plan_plan_type"
      fill_in "plan_start_location_name", with: "England"
      fill_in "plan_start_date", with: Time.current + 1.day
      click_on "Save"
      expect(page).to(have_content("Title is too long (maximum is 250 characters)"))
    end

    scenario "I cannot create a plan with no provided plan type" do
      visit new_plan_path
      fill_in "plan_title", with: "a" * 401
      fill_in "plan_start_location_name", with: "England"
      fill_in "plan_start_date", with: Time.current + 1.day
      click_on "Save"
      expect(page).to(have_content("Plan type is not included in the list"))
    end

    scenario "I cannot create a plan with no start location" do
      visit new_plan_path
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      fill_in "plan_start_date", with: Time.current + 1.day
      click_on "Save"
      expect(page).to(have_content("Start location name can't be blank"))
    end

    scenario "I cannot create a plan with no start date" do
      visit new_plan_path
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      fill_in "plan_start_location_name", with: "England"
      click_on "Save"
      expect(page).to(have_content("Start date can't be blank"))
    end

    scenario "I cannot create a plan with a start date after the end date" do
      visit new_plan_path
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      fill_in "plan_start_location_name", with: "England"
      fill_in "plan_start_date", with: Time.current + 2.days
      fill_in "plan_end_date", with: Time.current + 1.day
      click_on "Save"
      expect(page).to(have_content("Start date cannot be after end date"))
    end

    scenario "I cannot create a plan with a start date prior to the current time" do
      visit new_plan_path
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      fill_in "plan_start_location_name", with: "England"
      fill_in "plan_start_date", with: Time.current - 1.day
      click_on "Save"
      expect(page).to(have_content("Start date cannot be in the past"))
    end

    scenario "I cannot create a plan with no end location if it is a travel plan" do
      visit new_plan_path
      fill_in "plan_title", with: "Test Title"
      select "Travel By Plane", from: "plan_plan_type"
      fill_in "plan_start_location_name", with: "England"
      fill_in "plan_start_date", with: Time.current + 1.day
      fill_in "plan_end_date", with: Time.current + 2.days
      click_on "Save"
      expect(page).to(have_content("End location name must be present for travel plans"))
    end

    scenario "I can input an end location if I choose a travel plan", js: true do
      visit new_plan_path
      select "Travel By Plane", from: "plan_plan_type"
      sleep_for_js
      expect(find("#plan_end_location_name", visible: :all)).to(be_visible)
    end

    given!(:trip) { FactoryBot.create(:trip) }

    scenario "I can create a plan and see its information on the plans index page" do
      visit new_plan_path
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      fill_in "plan_start_location_name", with: "England"
      fill_in "plan_start_date", with: Time.current + 1.day
      click_on "Save"
      visit plans_path
      expect(page).to(have_content("Test Title"))
      expect(page).to(have_content("Other"))
      expect(page).to(have_content("England"))
      expect(page).to(have_content(Time.current.strftime("%H:%M")))
    end
  end

  feature "Edit a plan" do
    given!(:plan) { FactoryBot.create(:plan) }

    scenario "I can edit the start location of a plan and see it on the plan page" do
      visit plans_path
      within(:css, "section .dropdown") do
        find("button").click
        click_on "Edit"
      end

      fill_in "plan_start_location_name", with: "New Location"
      click_on "Save"
      expect(page).to(have_content("New Location"))
    end

    scenario "I can edit the type of plan" do
      visit plans_path
      within(:css, "section .dropdown") do
        find("button").click
        click_on "Edit"
      end

      select "Restaurant", from: "plan_plan_type"
      click_on "Save"
      expect(page).to(have_content("Restaurant"))
    end

    scenario "If I edit a plan and remove the title, I see an error message" do
      visit plans_path
      within(:css, "section .dropdown") do
        find("button").click
        click_on "Edit"
      end

      fill_in "plan_title", with: ""
      click_on "Save"
      expect(page).to(have_content("Title can't be blank"))
    end

    scenario "If I change the plan type to not a travel plan, the end location is removed", js: true do
      visit plans_path
      within(:css, "section .dropdown") do
        find("button").click
        click_on "Edit"
      end

      sleep_for_js
      expect(page).to(have_field("plan_end_location_name", with: plan.end_location_name))

      select "Restaurant", from: "plan_plan_type"
      sleep_for_js

      expect(page).not_to(have_field("plan_end_location_name", with: plan.end_location_name))
    end
  end

  feature "Delete a plan" do
    given!(:plan) { FactoryBot.create(:plan) }

    scenario "I can delete a plan and see it removed from the plans index page" do
      visit plans_path
      within(:css, "section .dropdown") do
        find("button").click
        click_on "Delete"
      end
      expect(page).not_to(have_content(plan.start_location_name))
    end
  end
end
