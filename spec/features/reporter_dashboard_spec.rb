# frozen_string_literal: true

require "rails_helper"
require "active_support/testing/time_helpers"

RSpec.feature("Reporter dashboard") do
  let!(:reporter) { create(:reporter) }

  feature "Reporter can view statistics on dashboard", js: true do
    before do
      login_as(reporter, scope: :user)

      # Wednesday, 10th January 2024 (Week 2)
      travel_to Time.zone.local(2024, 0o1, 10, 0o7, 0o0, 0o0)

      create(
        :landing_page_visit,
        country_code: "GB",
        # Wednesday, 10th January 2024 (Week 2)
        created_at: Time.zone.now,
      )

      create(
        :landing_page_visit,
        country_code: "GB",
        # Monday, 8th January 2024 (Week 2)
        created_at: Time.zone.local(2024, 0o1, 8, 0o7, 0o0, 0o0),
      )

      create(
        :landing_page_visit,
        country_code: "NL",
        # Monday, 1st January 2024 (Week 1)
        created_at: Time.zone.local(2024, 0o1, 1, 0o7, 0o0, 0o0),
      )

      create(
        :landing_page_visit,
        country_code: "BE",
        # Monday, 25th December 2023
        created_at: Time.zone.local(2023, 12, 25, 0o7, 0o0, 0o0),
      )

      visit reporter_dashboard_path
    end

    context "Reporter can view landing page views statistics" do
      scenario "Reporter can view landing page views for today" do
        within(:css, "#today-tab .row .landing-page-views-card") do
          expect(page).to(have_content(1))
        end
      end

      scenario "Reporter can view landing page views for week" do
        click_button "Week"
        within(:css, "#week-tab .row .landing-page-views-card") do
          expect(page).to(have_content(2))
        end
      end

      scenario "Reporter can view landing page views for month" do
        click_button "Month"
        within(:css, "#month-tab .row .landing-page-views-card") do
          expect(page).to(have_content(3))
        end
      end

      scenario "Reporter can view landing page views all time" do
        click_button "All Time"
        within(:css, "#all-time-tab .row .landing-page-views-card") do
          expect(page).to(have_content(4))
        end
      end

      scenario "Reporter can view landing page views by location" do
        within(:css, "#landing-countries") do
          gb_row = find("tr", text: "United Kingdom")
          expect(gb_row.text.split.last).to(eq("2"))
          ne_row = find("tr", text: "Netherlands")
          expect(ne_row.text.split.last).to(eq("1"))
          be_row = find("tr", text: "Belgium")
          expect(be_row.text.split.last).to(eq("1"))
        end
      end
    end
  end
end
