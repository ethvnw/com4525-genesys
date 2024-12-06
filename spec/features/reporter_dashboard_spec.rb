# frozen_string_literal: true

require "rails_helper"
require "active_support/testing/time_helpers"

RSpec.feature("Reporter dashboard") do
  let!(:reporter) { create(:reporter) }
  let!(:tier) { create(:subscription_tier, name: "Free") }
  let!(:app_feature_1) { create(:app_feature, name: "App Feature 1", engagement_counter: 5) }
  let!(:app_feature_2) { create(:app_feature, name: "App Feature 2", engagement_counter: 20) }
  let!(:app_feature_3) { create(:app_feature, name: "App Feature 3", engagement_counter: 0) }
  let!(:premium_tier) { create(:subscription_tier, name: "Premium", engagement_counter: 11) }
  let!(:group_tier) { create(:subscription_tier, name: "Group", engagement_counter: 33) }
  let!(:free_tier) { create(:subscription_tier, name: "Free", engagement_counter: 0) }

  feature "Reporter can view statistics on dashboard", js: true do
    before do
      login_as(reporter, scope: :user)

      # Wednesday, 10th January 2024 (Week 2)
      travel_to Time.zone.local(2024, 0o1, 10, 0o7, 0o0, 0o0)

      # Landing page views

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

      # Registrations

      create(
        :registration,
        email: "test@example.com",
        country_code: "US",
        # Wednesday, 10th January 2024 (Week 2)
        created_at: Time.zone.now,
      )

      create(
        :registration,
        email: "test2@example.com",
        country_code: "US",
        # Monday, 8th January 2024 (Week 2)
        created_at: Time.zone.local(2024, 0o1, 8, 0o7, 0o0, 0o0),
      )

      create(
        :registration,
        email: "test3@example.com",
        country_code: "IE",
        # Monday, 1st January 2024 (Week 1)
        created_at: Time.zone.local(2024, 0o1, 1, 0o7, 0o0, 0o0),
      )

      create(
        :registration,
        email: "test4@example.com",
        country_code: "SG",
        # Monday, 25th December 2023
        created_at: Time.zone.local(2023, 12, 25, 0o7, 0o0, 0o0),
      )

      tier.app_features << [app_feature_1, app_feature_2, app_feature_3]

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

    context "Reporter can view registration statistics" do
      scenario "Reporter can view registrations for today" do
        within(:css, "#today-tab .row .registrations-card") do
          expect(page).to(have_content(1))
        end
      end

      scenario "Reporter can view registrations for week" do
        click_button "Week"
        within(:css, "#week-tab .row .registrations-card") do
          expect(page).to(have_content(2))
        end
      end

      scenario "Reporter can view registrations for month" do
        click_button "Month"
        within(:css, "#month-tab .row .registrations-card") do
          expect(page).to(have_content(3))
        end
      end

      scenario "Reporter can view registrations all time" do
        click_button "All Time"
        within(:css, "#all-time-tab .row .registrations-card") do
          expect(page).to(have_content(4))
        end
      end

      scenario "Reporter can view registrations by location" do
        click_button "Registrations"
        within(:css, "#registration-countries") do
          us_row = find("tr", text: "United States")
          expect(us_row.text.split.last).to(eq("2"))
          sg_row = find("tr", text: "Singapore")
          expect(sg_row.text.split.last).to(eq("1"))
          ie_row = find("tr", text: "Ireland")
          expect(ie_row.text.split.last).to(eq("1"))
        end
      end
    end

    scenario "Reporter can view feature engagement" do
      click_button "Features"
      within(:css, "#engagement-features") do
        row_1 = find("tr", text: app_feature_1.name)
        expect(row_1.text.split.last).to(eq("5"))
        row_2 = find("tr", text: app_feature_2.name)
        expect(row_2.text.split.last).to(eq("20"))
        row_3 = find("tr", text: app_feature_3.name)
        expect(row_3.text.split.last).to(eq("0"))
      end
    end

    scenario "Reporter can view pricing engagement" do
      click_button "Pricing"
      within(:css, "#engagement-pricing") do
        row_1 = find("tr", text: premium_tier.name)
        expect(row_1.text.split.last).to(eq("11"))
        row_2 = find("tr", text: group_tier.name)
        expect(row_2.text.split.last).to(eq("33"))
        row_3 = find("tr", text: free_tier.name)
        expect(row_3.text.split.last).to(eq("0"))
      end
    end
  end
end
