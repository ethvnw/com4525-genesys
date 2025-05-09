# frozen_string_literal: true

require "rails_helper"
require_relative "../support/helpers/trips_and_plans_helper"

RSpec.feature("Managing plans") do
  let!(:user) { create(:user) }
  let!(:trip) { create(:trip) }
  let!(:trip_membership) { create(:trip_membership, user: user, trip: trip) }

  before do
    trip_membership # Prevent lazy evaluation
    login_as(user, scope: :user)
    freeze_time
  end

  feature "Creating plans" do
    scenario "I cannot create a plan with no title", js: true do
      visit new_trip_plan_path(trip)
      select "Other", from: "plan_plan_type"
      select_location("England")
      fill_in "plan_start_date", with: Time.current + 1.day
      click_on "Save"
      expect(page).to(have_content("Title can't be blank"))
    end

    scenario "I cannot create a plan with a title that is too long (>250 characters)", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "a" * 300
      select "Other", from: "plan_plan_type"
      select_location("England")
      fill_in "plan_start_date", with: Time.current + 1.day
      click_on "Save"
      expect(page).to(have_content("Title is too long (maximum is 250 characters)"))
    end

    scenario "I cannot create a plan with no provided plan type", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "a"
      select_location("England")
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
      select_location("England")
      click_on "Save"
      expect(page).to(have_content("Start date can't be blank"))
    end

    scenario "I cannot create a plan with a start date after the end date", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      select_location("England")
      fill_in "plan_start_date", with: Time.current + 2.days
      fill_in "plan_end_date", with: Time.current + 1.day
      click_on "Save"
      expect(page).to(have_content("Start date cannot be after end date"))
    end

    scenario "I cannot create a plan with a start date prior to the current time", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      select_location("England")
      fill_in "plan_start_date", with: Time.current - 1.day
      click_on "Save"
      expect(page).to(have_content("Start date cannot be in the past"))
    end

    scenario "I cannot create a plan with no end location if it is a travel plan", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Travel By Plane", from: "plan_plan_type"
      select_location("England")
      fill_in "plan_start_date", with: Time.current + 1.day
      fill_in "plan_end_date", with: Time.current + 2.days
      click_on "Save"
      expect(page).to(have_content("End location name must be present for travel plans"))
    end

    scenario "I can input an end location if I choose a travel plan", js: true do
      visit new_trip_plan_path(trip)
      select "Travel By Plane", from: "plan_plan_type"
      expect(page).to(have_selector("#end-location-autocomplete", visible: true))
    end

    scenario "I can create a plan with fewer fields to fill if I choose a free time plan", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Free Time", from: "plan_plan_type"
      fill_in "plan_start_date", with: Time.current + 1.day
      expect(page).to(have_selector("#start-location-autocomplete", visible: false))
      click_on "Save"

      await_message("Plan created successfully")

      expect(page).to(have_content("Test Title"))
      expect(page).to(have_content("Free Time"))
      expect(page).to(have_content(Time.current.strftime("%H:%M")))
    end

    scenario "I can create a plan and see its information on the plans index page", js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      select_location("England")
      fill_in "plan_start_date", with: Time.current + 1.day
      click_on "Save"

      await_message("Plan created successfully")

      expect(page).to(have_content("Test Title"))
      expect(page).to(have_content("Other"))
      expect(page).to(have_content("England"))
      expect(page).to(have_content(Time.current.strftime("%H:%M")))
    end

    scenario "I can create 2 plans within the same day and see their information on the plans index page",
      js: true do
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      select_location("England")
      fill_in "Start date", with: Time.current + 1.day
      click_on "Save"
      visit new_trip_plan_path(trip)
      fill_in "plan_title", with: "Test Title 2"
      select "Other", from: "plan_plan_type"
      select_location("Brazil")
      fill_in "Start date", with: Time.current + 1.day + 2.hours
      click_on "Save"

      await_message("Plan created successfully")

      expect(page).to(have_content("England"))
      expect(page).to(have_content("Brazil"))
    end
  end

  feature "Edit a plan" do
    let!(:plan) { create(:plan, trip: trip) }

    scenario "I can edit the start location of a plan and see it on the plan page", js: true do
      visit trip_path(plan.trip_id)
      within(:css, "section #plan-settings.dropdown") do
        find("button").click
        click_on "Edit Plan"
      end

      select_location("Brazil")
      click_on "Save"
      await_message("Plan updated successfully")
      expect(page).not_to(have_content("England"))
    end

    scenario "I can edit the type of plan" do
      visit trip_path(plan.trip_id)
      within(:css, "section #plan-settings.dropdown") do
        find("button").click
        click_on "Edit Plan"
      end

      select "Restaurant", from: "plan_plan_type"
      click_on "Save"
      await_message("Plan updated successfully")
      expect(page).to(have_content("Restaurant"))
    end

    scenario "If I edit a plan and remove the title, I see an error message" do
      visit trip_path(plan.trip_id)
      within(:css, "section #plan-settings.dropdown") do
        find("button").click
        click_on "Edit Plan"
      end

      fill_in "plan_title", with: ""
      click_on "Save"
      expect(page).to(have_content("Title can't be blank"))
    end

    scenario "If I change the plan type to not a travel plan, the end location is removed", js: true do
      visit trip_path(plan.trip_id)
      within(:css, "section #plan-settings.dropdown") do
        find("button").click
        click_on "Edit Plan"
      end
      expect(find("#end-location-autocomplete", visible: :all, wait: 5)).to(be_visible)
      select "Restaurant", from: "plan_plan_type"
      expect(find("#end-location-autocomplete", visible: :all, wait: 5)).not_to(be_visible)
    end

    scenario "I can edit a plan and change the provider name" do
      visit trip_path(plan.trip_id)
      within(:css, "section #plan-settings.dropdown") do
        find("button").click
        click_on "Edit Plan"
      end

      fill_in "plan_provider_name", with: "New Provider Name"
      click_on "Save"

      await_message("Plan updated successfully")
      expect(page).to(have_content("New Provider Name"))
    end

    scenario "I can edit a plan and remove the provider name" do
      visit trip_path(plan.trip_id)

      # Check company name exists already
      expect(page).to(have_content(plan.provider_name))

      within(:css, "section #plan-settings.dropdown") do
        find("button").click
        click_on "Edit Plan"
      end

      fill_in "plan_provider_name", with: ""
      click_on "Save"

      await_message("Plan updated successfully")

      # Check company name is now removed
      expect(page).not_to(have_content(plan.provider_name))
    end
  end

  feature "Delete a plan" do
    let!(:plan) { create(:plan, trip: trip) }

    scenario "I can delete a plan and see it removed from the plans index page" do
      visit trip_path(plan.trip_id)
      expect(page).to(have_content(plan.start_location_name))
      within(:css, "section #plan-settings.dropdown") do
        find("button").click
        click_on "Delete Plan"
      end
      await_message("Plan deleted successfully")
      expect(page).not_to(have_content(plan.start_location_name))
    end
  end

  feature "Creating backup plans" do
    context "When the plan created doesn't already have a backup plan" do
      let!(:plan) { create(:plan, trip: trip) }

      scenario "I can create a backup plan for a pre-existing plan and view its details" do
        visit trip_path(plan.trip_id)
        within(:css, "section #plan-settings.dropdown") do
          find("button").click
          click_on "Add Backup Plan"
        end

        fill_in "plan_title", with: "Backup Title"
        select "Free Time", from: "plan_plan_type"
        click_on "Save"

        await_message("Plan created successfully")
        find("button.swiper-toggle-button").click
        expect(page).to(have_content("Backup Title"))
      end
    end

    context "When the plan created already has a backup plan" do
      let!(:plan_backup) { create(:plan, trip: trip, title: "Premade Backup") }
      let!(:plan) { create(:plan, trip: trip, backup_plan_id: plan_backup.id, title: "Premade Plan") }

      scenario "I cannot create a backup plan for a plan that already has a backup plan" do
        visit trip_path(plan.trip_id)
        within(:css, "section #plan-settings.dropdown") do
          find("button").click
          expect(page).not_to(have_content("Add Backup Plan"))
        end
      end

      scenario "I cannot create a backup plan for a backup plan" do
        visit trip_path(plan.trip_id)
        find("button.swiper-toggle-button").click
        within(:css, "section #plan-settings.dropdown") do
          find("button").click
          expect(page).not_to(have_content("Add Backup Plan"))
        end
      end
    end
  end

  feature "Viewing plans" do
    let!(:plan) { create(:plan, trip: trip) }
    let!(:plan_later) do
      create(
        :plan,
        trip: trip,
        title: "Later Plan",
        start_date: Time.current + 3.days,
        end_date: Time.current + 4.days,
      )
    end

    scenario "If a plan doesn't have a scannable ticket, I see a message indicating that", js: true do
      visit trip_plan_path(trip, plan)
      # Expect a notice indicating no scannable tickets to be present
      expect(page).to(have_content("No tickets available for this plan."))
    end

    scenario "If I click 'Desc' to sort plans, the order in which plans are displayed is changed", js: true do
      visit trip_path(plan.trip_id)
      expect(page.first("[id^='plan-']")).to(have_content("Mock Plan"))
      click_on "Desc"
      expect(page).to(have_content("Asc"))
      expect(page.first("[id^='plan-']")).to(have_content("Later Plan"))
    end
  end
end
