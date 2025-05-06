# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Dashboard access") do
  let(:admin) { create(:admin) }
  let(:reporter) { create(:reporter) }
  let(:user) { create(:user) }

  feature "As an admin user" do
    before do
      login_as(admin, scope: :user)
    end

    specify "I am authorised to view the admin dashboard" do
      visit admin_dashboard_path
      expect(page).to(have_content("Admin Dashboard"))
    end

    specify "I am authorised to view the reporter dashboard" do
      visit analytics_landing_page_path
      expect(page).to(have_content("Landing Page Analytics"))

      visit analytics_trips_path
      expect(page).to(have_content("Trip Analytics"))

      visit analytics_referrals_path
      expect(page).to(have_content("Referrals Analytics"))
    end
  end

  feature "As a reporter" do
    before do
      login_as(reporter, scope: :user)
    end

    specify "I am authorised to view the reporter dashboard" do
      visit analytics_landing_page_path
      expect(page).to(have_content("Landing Page Analytics"))

      visit analytics_trips_path
      expect(page).to(have_content("Trip Analytics"))

      visit analytics_referrals_path
      expect(page).to(have_content("Referrals Analytics"))
    end

    specify "I am unauthorised to view the admin dashboard" do
      visit admin_dashboard_path
      expect(page.status_code).to(eq(401))
    end
  end

  feature "As a regular user" do
    before do
      login_as(user, scope: :user)
    end

    specify "I am unauthorised to view the admin dashboard" do
      visit admin_dashboard_path
      expect(page.status_code).to(eq(401))
    end

    specify "I am unauthorised to view the reporter dashboard" do
      visit analytics_landing_page_path
      expect(page.status_code).to(eq(401))

      visit analytics_trips_path
      expect(page.status_code).to(eq(401))

      visit analytics_referrals_path
      expect(page.status_code).to(eq(401))
    end
  end
end
