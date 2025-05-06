# frozen_string_literal: true

require "rails_helper"
require_relative "../support/helpers/trips_and_plans_helper"

RSpec.feature("Viewing trip details") do
  let(:user) { create(:user) }
  let(:trip) do
    create(
      :trip,
      title: "Mock Trip 1",
      start_date: Time.zone.parse("2020-01-02"),
      end_date: Time.zone.parse("2020-01-16"),
      location_latitude: 50,
      location_longitude: 50,
    )
  end

  before do
    login_as(user, scope: :user)
    time_travel_everywhere(Time.zone.parse("2020-01-01 00:00:00"))
    create(:trip_membership, trip: trip, user: user)
  end

  context "When the trip has no plans" do
    scenario "Viewing my trip" do
      visit trip_path(trip)
      click_on "List"

      expect(page).to(have_content("No plans have been added to this trip yet"))
    end

    scenario "Viewing my trip as a map" do
      visit trip_path(trip)
      click_on "Map"

      expect(page).to(have_content("No plans have been added to this trip yet"))
    end
  end

  context "When the trip has plans" do
    let!(:plan) do
      create(
        :plan,
        trip: trip,
        start_date: Time.zone.parse("2020-01-02 07:00"),
        end_date: Time.zone.parse("2020-01-02 09:00"),
        plan_type: "other",
      )
    end
    let!(:plan2) do
      create(
        :plan,
        trip: trip,
        start_date: Time.zone.parse("2020-01-05 09:00"),
        end_date: Time.zone.parse("2020-01-05 11:00"),
        plan_type: "other",
      )
    end
    let!(:travel_plan) do
      create(
        :plan,
        trip: trip,
        start_date: Time.zone.parse("2020-01-05 15:00"),
        end_date: Time.zone.parse("2020-01-05 17:00"),
      )
    end

    scenario "Viewing my trip as a list" do
      visit trip_path(trip)
      click_on "List"

      within(".collapse-btn[data-bs-target='#plans0']") do |collapse_button|
        expect(collapse_button).to(have_content("Thursday 02 Jan"))
      end

      within("#plans0 #plan-#{plan.id}") do |plan_card|
        expect(plan_card).to(have_content("07:00"))
        expect(plan_card).to(have_content(plan.title))
        expect(plan_card).to(have_content(plan.plan_type.titleize))
        expect(plan_card).to(have_content(plan.start_location_name))
      end

      within(".collapse-btn[data-bs-target='#plans1']") do |collapse_button|
        expect(collapse_button).to(have_content("Sunday 05 Jan"))
      end

      within("#plans1 #plan-#{plan2.id}") do |plan_card|
        expect(plan_card).to(have_content("09:00"))
        expect(plan_card).to(have_content(plan2.title))
        expect(plan_card).to(have_content(plan2.plan_type.titleize))
        expect(plan_card).to(have_content(plan2.start_location_name))
      end

      within("#plans1 #plan-#{travel_plan.id}") do |plan_card|
        expect(plan_card).to(have_content("15:00"))
        expect(plan_card).to(have_content(travel_plan.title))
        expect(plan_card).to(have_content(travel_plan.start_location_name))
        expect(plan_card).to(have_content(travel_plan.end_location_name))
      end
    end

    scenario "Viewing my trip as a map", js: true do
      visit trip_path(trip)
      click_on "Map"

      within(".leaflet-div-icon a[href='/trips/#{trip.id}/plans/#{plan.id}/edit']") do |plan_marker|
        expect(plan_marker).to(have_content(plan.title))
      end

      within(".leaflet-div-icon a[href='/trips/#{trip.id}/plans/#{plan2.id}/edit']") do |plan_marker|
        expect(plan_marker).to(have_content(plan.title))
      end

      travel_plan_start = find_all(".leaflet-div-icon a[href='/trips/#{trip.id}/plans/#{travel_plan.id}/edit']").first
      travel_plan_end = find_all(".leaflet-div-icon a[href='/trips/#{trip.id}/plans/#{travel_plan.id}/edit']").last

      expect(travel_plan_start).to(have_content(travel_plan.title))
      expect(travel_plan_start).to(have_content("Start"))
      expect(travel_plan_end).to(have_content(travel_plan.title))
      expect(travel_plan_end).to(have_content("End"))

      plan_information = JSON.parse(page.find("#map-variables", visible: false)["data-marker-coords"])

      expect(plan_information).to(include({
        "id" => plan.id,
        "title" => plan.title,
        "coords" => [plan.start_location_latitude, plan.start_location_longitude],
        "href" => "/trips/#{trip.id}/plans/#{plan.id}/edit",
      }))

      expect(plan_information).to(include({
        "id" => plan2.id,
        "title" => plan2.title,
        "coords" => [plan2.start_location_latitude, plan2.start_location_longitude],
        "href" => "/trips/#{trip.id}/plans/#{plan2.id}/edit",
      }))

      expect(plan_information).to(include({
        "id" => travel_plan.id,
        "title" => travel_plan.title,
        "coords" => [travel_plan.start_location_latitude, travel_plan.start_location_longitude],
        "endCoords" => [travel_plan.end_location_latitude, travel_plan.end_location_longitude],
        "icon" => ["bi bi-airplane-fill"],
        "href" => "/trips/#{trip.id}/plans/#{travel_plan.id}/edit",
      }))
    end

    scenario "Viewing my trip as a downloadable PDF", js: true do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Export PDF"

      download_file = Rails.root.join(DOWNLOAD_PATH, "#{trip.title}.pdf")
      Timeout.timeout(15) do
        sleep(0.1) until File.exist?(download_file)
      end

      expect(File).to(exist(download_file))
      pdf = File.read(download_file)
      expect(pdf).to(include(trip.title))
    end
  end
end
