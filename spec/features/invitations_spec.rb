# frozen_string_literal: true

require "rails_helper"
require "invitations_helper"

RSpec.feature("Invitations") do
  let(:admin) { create(:admin) }

  before do
    login_as(admin, scope: :user)
    visit admin_dashboard_path
  end

  feature "Invitation form visibility" do
    specify "A send invitation form will be visible the admin dashboard" do
      expect(page).to(have_content("Create Staff Account"))
      expect(page).to(have_field("Email address"))

      expect(page).to(have_select("user_user_role", options: ["Role"] + User.user_roles.values))
      expect(page).to(have_button("Send Invitation"))
    end
  end

  feature "Submitting an invitation to a new email address" do
    specify "I can submit an invitation and give admin privileges" do
      submit_invitation_to_new_email("new_admin@genesys.com", "Admin")
    end

    specify "I can submit an invitation and give reporter privileges" do
      submit_invitation_to_new_email("new_reporter@genesys.com", "Reporter")
    end
  end

  feature "Submitting an invitation to an existing email address" do
    specify "I cannot submit an invitation to a user that already exists" do
      # Send an invitation to an existing email address
      fill_in("Email address", with: admin.email)
      select("Admin", from: "user_user_role")
      click_button("Send Invitation")
      within("#toast-list .text-bg-danger") do
        expect(page).to(have_content("Email has already been taken"))
      end
    end
  end

  feature "Prevent access to the default invitations page" do
    specify "Accessing the default new invitation path gives a 404" do
      visit new_user_invitation_path
      expect(page.status_code).to(eq(404))
    end
  end
end
