# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing staff") do
  let(:admin) { create(:admin) }
  let!(:reporter) { create(:reporter) }

  before do
    login_as(admin, scope: :user)
    visit admin_dashboard_path
  end

  feature "Access staff account" do
    specify "I want to be able to view a staff user's account" do
      expect(page).to(have_content("Staff Accounts"))

      within("#staff-table") do
        expect(page).to(have_text(reporter.email))
        row = find("tr", text: reporter.email)
        within(row) do
          click_link("View Account")
        end
      end

      expect(page).to(have_content("Edit User"))
      expect(page).to(have_content("Account Email: #{reporter.email}"))
    end
  end

  feature "Edit staff role" do
    specify "I want to be able to edit a staff user's role from reporter to admin" do
      within("#staff-table") do
        row = find("tr", text: reporter.email)
        within(row) do
          # Check the staff's current role is reporter
          expect(row).to(have_text("Reporter"))
          click_link("View Account")
        end
      end

      select("Admin", from: "user_user_role")
      click_button("Save Changes")

      within("#page-alert.alert-success") do
        expect(page).to(have_content("#{reporter.email} updated successfully."))
      end

      within("#staff-table") do
        row = find("tr", text: reporter.email)
        within(row) do
          # Check the staff's current role is now admin
          expect(row).to(have_text("Admin"))
        end
      end
    end
  end

  feature "Remove access from staff" do
    specify "I want to be able to remove access from a user's account" do
      within("#staff-table") do
        row = find("tr", text: reporter.email)
        within(row) do
          click_link("View Account")
        end
      end

      click_button("Remove Access")

      within("#page-alert.alert-success") do
        expect(page).to(have_content("Access removed for #{reporter.email}"))
      end

      # The staff should also no longer appear on the admin's dashboard
      within("#staff-table") do
        expect(page).not_to(have_selector("tr", text: reporter.email))
      end

      expect(User.exists?(email: reporter.email)).to(be_falsey)
    end
  end
end
