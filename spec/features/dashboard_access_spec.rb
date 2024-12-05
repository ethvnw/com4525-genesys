# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Dashboard access") do
  let(:admin) { create(:admin) }
  let(:reporter) { create(:reporter) }
  let(:user) { create(:user) }

  feature "Admin access to admin and reporter dashboards" do
    before do
      login_as(admin, scope: :user)
    end

    specify "I am authorised to view the admin dashboard" do
      visit admin_dashboard_path
      expect(page).to(have_content("Admin Dashboard"))
    end

    specify "I am authorised to view the reporter dashboard" do
      visit reporter_dashboard_path
      expect(page).to(have_content("Reporter Dashboard"))
    end
  end

  feature "Reporter access to reporter dashboard but not admin dashboard" do
    before do
      login_as(reporter, scope: :user)
    end

    specify "I am authorised to view the reporter dashboard" do
      visit reporter_dashboard_path
      expect(page).to(have_content("Reporter Dashboard"))
    end

    specify "I am unauthorised to view the admin dashboard" do
      visit admin_dashboard_path
      expect(page.status_code).to(eq(401))
    end
  end

  feature "Inability to access admin or reporter dashboards as a regular user" do
    before do
      login_as(user, scope: :user)
    end

    specify "I am unauthorised to view the admin dashboard" do
      visit admin_dashboard_path
      expect(page.status_code).to(eq(401))
    end

    specify "I am unauthorised to view the reporter dashboard" do
      visit reporter_dashboard_path
      expect(page.status_code).to(eq(401))
    end
  end
end
