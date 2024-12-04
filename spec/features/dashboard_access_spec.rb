# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Dashboard access") do
  let(:admin) { create(:admin) }
  let(:reporter) { create(:reporter) }
  let(:user) { create(:user) }

  feature "Admin access to admin and reporter dashboards" do
    specify "I am authorised to view the admin dashboard" do
      login_as(admin, scope: :user)
      visit admin_dashboard_path
      expect(page).to(have_content("Admin Dashboard"))
    end

    specify "I am authorised to view the reporter dashboard" do
      login_as(admin, scope: :user)
      visit reporter_dashboard_path
      expect(page).to(have_content("Reporter Dashboard"))
    end
  end

  feature "Reporter access to reporter dashboard but not admin dashboard" do
    specify "I am authorised to view the reporter dashboard" do
      login_as(reporter, scope: :user)
      visit reporter_dashboard_path
      expect(page).to(have_content("Reporter Dashboard"))
    end

    specify "I am unauthorised to view the admin dashboard" do
      login_as(reporter, scope: :user)
      visit admin_dashboard_path

      within(".alert.alert-danger") do
        expect(page).to(have_content("Unauthorized Access."))
      end
    end
  end

  feature "Inability to access admin or reporter dashboards as a regular user" do
    specify "I am unauthorised to view the admin dashboard" do
      login_as(user, scope: :user)
      visit admin_dashboard_path
      within(".alert.alert-danger") do
        expect(page).to(have_content("Unauthorized Access."))
      end
    end

    specify "I am unauthorised to view the reporter dashboard" do
      login_as(user, scope: :user)
      visit reporter_dashboard_path
      within(".alert.alert-danger") do
        expect(page).to(have_content("Unauthorized Access."))
      end
    end
  end
end
