# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Viewing Landing Page Journeys") do
  let(:admin) { create(:admin) }
  let!(:registration) { create(:registration, country_code: "GB", created_at: Time.zone.parse("2024-01-01, 09:30")) }

  before do
    login_as(admin, scope: :user)
    visit admin_dashboard_path
  end

  feature "viewing all registrations" do
    specify "all registrations should be visible on the admin dashboard" do
      create(
        :registration,
        country_code: "NL",
        email: "test2@example.com",
        created_at: Time.zone.parse("2024-03-23, 13:30"),
      )
      create(
        :registration,
        country_code: "FR",
        email: "test3@example.com",
        created_at: Time.zone.parse("2024-08-14, 08:30"),
      )
      create(
        :registration,
        country_code: "BE",
        email: "test4@example.com",
        created_at: Time.zone.parse("2024-10-31, 08:30"),
      )

      visit admin_dashboard_path # refresh to reload new registrations

      within("#registrations-table") do
        expect(page).to(have_text(registration.email))
        row = find("tr", text: registration.email)
        expect(row).to(have_text("🇬🇧 United Kingdom"))
        expect(row).to(have_text("January 01, 2024 09:30 AM"))

        row = find("tr", text: "test2@example.com")
        expect(row).to(have_text("🇳🇱 Netherlands"))
        expect(row).to(have_text("March 23, 2024 01:30 PM"))

        row = find("tr", text: "test3@example.com")
        expect(row).to(have_text("🇫🇷 France"))
        expect(row).to(have_text("August 14, 2024 08:30 AM"))

        row = find("tr", text: "test4@example.com")
        expect(row).to(have_text("🇧🇪 Belgium"))
        expect(row).to(have_text("October 31, 2024 08:30 AM"))
      end
    end
  end

  feature "viewing landing page journey" do
    before do
      create(
        :feature_share,
        registration: registration,
        share_method: "email",
        created_at: Time.zone.parse("2024-01-01 09:00:45"),
        app_feature: create(:app_feature, name: "Sample Feature 1"),
      )
      create(
        :feature_share,
        registration: registration,
        share_method: "whatsapp",
        created_at: Time.zone.parse("2024-01-01 09:01:21"),
        app_feature: create(:app_feature, name: "Sample Feature 2"),
      )

      create(
        :question_click,
        registration: registration,
        created_at: Time.zone.parse("2024-01-01 09:05:47"),
        question: create(:question, question: "Sample Question 1"),
      )
      create(
        :question_click,
        registration: registration,
        created_at: Time.zone.parse("2024-01-01 09:07:18"),
        question: create(:question, question: "Sample Question 2"),
      )

      create(
        :review_like,
        registration: registration,
        created_at: Time.zone.parse("2024-01-01 09:01:36"),
        review: create(:review, content: "Sample Review 1"),
      )
      create(
        :review_like,
        registration: registration,
        created_at: Time.zone.parse("2024-01-01 09:02:43"),
        review: create(:review, content: "Sample Review 2"),
      )
    end

    specify "an admin should be able to view the landing page journey that led to a registration" do
      within("#registrations-table") do
        row = find("tr", text: registration.email)
        within(row) do
          click_link("View Journey")
        end
      end

      # Check each li element to assert that journey is presented in the correct order
      within find("li:nth-child(1)") do
        expect(page).to(have_text("Shared using Email"))
        expect(page).to(have_text("Sample Feature 1"))
        expect(page).to(have_text("January 01, 2024 09:00 AM"))
      end

      within find("li:nth-child(2)") do
        expect(page).to(have_text("Shared using Whatsapp"))
        expect(page).to(have_text("Sample Feature 2"))
        expect(page).to(have_text("January 01, 2024 09:01 AM"))
      end

      within find("li:nth-child(3)") do
        expect(page).to(have_text("Liked Review"))
        expect(page).to(have_text("Sample Review 1"))
        expect(page).to(have_text("January 01, 2024 09:01 AM"))
      end

      within find("li:nth-child(4)") do
        expect(page).to(have_text("Liked Review"))
        expect(page).to(have_text("Sample Review 2"))
        expect(page).to(have_text("January 01, 2024 09:02 AM"))
      end

      within find("li:nth-child(5)") do
        expect(page).to(have_text("Clicked on Question"))
        expect(page).to(have_text("Sample Question 1"))
        expect(page).to(have_text("January 01, 2024 09:05 AM"))
      end

      within find("li:nth-child(6)") do
        expect(page).to(have_text("Clicked on Question"))
        expect(page).to(have_text("Sample Question 2"))
        expect(page).to(have_text("January 01, 2024 09:07 AM"))
      end

      within find("li:nth-child(7)") do
        expect(page).to(have_text("Subscribed to Tier"))
        expect(page).to(have_text("Free"))
        expect(page).to(have_text("January 01, 2024 09:30 AM"))
      end
    end
  end
end
