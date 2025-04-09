# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing plans") do
  let(:user) { create(:user) }
  let(:trip) { create(:trip) }
  let(:trip_membership) { create(:trip_membership, user: user, trip: trip) }

  before do
    trip_membership # Prevent lazy evaluation
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
      sleep_for_js
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("England")

      find_all(".aa-Item").first.click
      fill_in "Start date", with: Time.current + 1.day
      click_on "Save"
      sleep_for_js
      visit new_trip_plan_path(trip)
      sleep_for_js
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

    scenario "I can add a QR code to a plan and see a preview of it", js: true do
      visit new_trip_plan_path(trip)
      # qr_hello_world.png is a QR code that contains the data "Hello World!"
      attach_file("qr_codes_upload", Rails.root.join("spec", "support", "files", "qr_hello_world.png"))
      # Cannot do canvas tests with Capybara, so the text preview is checked for successful processing.
      expect(page).to(have_selector("canvas"))
      expect(page).to(have_content("Extracted QR Code Data: Hello World!"))
      expect(page).to(have_content("1 of 1"))
    end

    scenario "I can add a QR code to a plan and see it on the show page", js: true do
      visit new_trip_plan_path(trip)
      sleep_for_js
      fill_in "plan_title", with: "Test Title"
      select "Other", from: "plan_plan_type"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("England")
      find_all(".aa-Item").first.click
      fill_in "Start date", with: Time.current + 1.day
      attach_file("qr_codes_upload", Rails.root.join("spec", "support", "files", "qr_hello_world.png"))
      expect(page).to(have_content("Extracted QR Code Data: Hello World!"))
      click_on "Save"
      sleep_for_js
      visit trip_plan_path(trip, Plan.first)
      # Expect the QR code text to be present on the plan page
      expect(page).to(have_content("Hello World!"))
    end
  end

  feature "Edit a plan" do
    given!(:plan) { create(:plan, trip: trip) }
    let(:plan_with_ticket) { create(:scannable_ticket, plan: create(:plan, trip: trip)).plan }

    scenario "I can edit the start location of a plan and see it on the plan page", js: true do
      visit trip_path(plan.trip_id)
      within(:css, "section #plan-settings.dropdown") do
        find("button").click
        click_on "Edit Plan"
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
        click_on "Edit Plan"
      end

      select "Restaurant", from: "plan_plan_type"
      click_on "Save"
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

      sleep_for_js
      expect(find("#end-location-autocomplete", visible: :all)).to(be_visible)

      select "Restaurant", from: "plan_plan_type"
      sleep_for_js

      expect(find("#end-location-autocomplete", visible: :all)).not_to(be_visible)
    end

    scenario "I can add additional QR codes to a plan and see them on the plan page", js: true do
      visit trip_plan_path(trip, plan_with_ticket)
      # Expect the QR code text to be present on the plan page
      expect(page).to(have_content("Mock ticket code"))
      expect(page).to(have_content("1 of 1"))
      visit edit_trip_plan_path(trip, plan_with_ticket)
      # Add an new ticket with a different QR code value
      attach_file("qr_codes_upload", Rails.root.join("spec", "support", "files", "qr_hello_world.png"))
      sleep_for_js
      click_on "Save"
      # Expect the "already existed" notice to not be present
      expect(page).not_to(have_content("Some QR codes already existed..."))
      # Expect there to now be two QR codes
      visit trip_plan_path(trip, plan_with_ticket)
      expect(page).to(have_content("1 of 2"))
    end

    scenario "If I try to add an already existing QR code, a notice is shown and it is not added", js: true do
      visit trip_plan_path(trip, plan_with_ticket)
      # Expect the QR code text to be present on the plan page
      expect(page).to(have_content("Mock ticket code"))
      expect(page).to(have_content("1 of 1"))
      visit edit_trip_plan_path(trip, plan_with_ticket)
      # qr_mock.png is a QR code that contains the data "Mock ticket code"
      attach_file("qr_codes_upload", Rails.root.join("spec", "support", "files", "qr_mock.png"))
      sleep_for_js
      click_on "Save"
      # Expect a notice indicating the QR code already exists
      expect(page).to(have_content("Some QR codes already existed..."))
      # Expect there to still only be one QR code
      visit trip_plan_path(trip, plan_with_ticket)
      expect(page).to(have_content("1 of 1"))
    end
  end

  feature "Delete a plan" do
    given!(:plan) { create(:plan, trip: trip) }

    scenario "I can delete a plan and see it removed from the plans index page" do
      visit trip_path(plan.trip_id)
      expect(page).to(have_content(plan.start_location_name))
      within(:css, "section #plan-settings.dropdown") do
        find("button").click
        click_on "Delete Plan"
      end
      expect(page).not_to(have_content(plan.start_location_name))
    end
  end

  feature "Viewing plans" do
    given!(:plan) { create(:plan, trip: trip) }
    let(:plan_with_ticket) { create(:scannable_ticket, plan: create(:plan, trip: trip)).plan }

    scenario "If a plan doesn't have a scannable ticket, I see a message indicating that", js: true do
      visit trip_plan_path(trip, plan)
      # Expect a notice indicating no scannable tickets to be present
      expect(page).to(have_content("No tickets available for this plan."))
    end
  end
end
