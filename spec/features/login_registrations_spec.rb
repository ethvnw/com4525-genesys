# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Login and Registrations") do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user, email: "test2@epigenesys.org.uk", username: "MockUser2") }

  feature "User login" do
    scenario "I can use my email to login" do
      visit new_user_session_path

      fill_in "Email address or Username", with: user.email
      fill_in "Password", with: "GenesysModule#1"
      click_button "Log In"

      expect(page).to(have_current_path(home_path))
      expect(page).to(have_content("Signed in successfully."))
    end

    scenario "I can use my username to login" do
      visit new_user_session_path

      fill_in "Email address or Username", with: user.username
      fill_in "Password", with: "GenesysModule#1"
      click_button "Log In"

      expect(page).to(have_current_path(home_path))
      expect(page).to(have_content("Signed in successfully."))
    end
  end

  feature "Editing username" do
    before do
      login_as(user, scope: :user)
      visit edit_user_registration_path
    end

    scenario "I cannot edit my username to one that already exists" do
      fill_in "Username", with: user2.username
      fill_in "Current password", with: "GenesysModule#1"
      click_button "Apply Changes"

      expect(page).to(have_content("Username has already been taken"))
    end

    scenario "I can edit my username to one that does not already exist" do
      fill_in "Username", with: "new_unique_username"
      fill_in "Current password", with: "GenesysModule#1"
      click_button "Apply Changes"

      expect(page).to(have_content("Account updated successfully"))
      expect(user.reload.username).to(eq("new_unique_username"))
    end

    scenario "I can edit my username to one that does not already exist and login" do
      fill_in "Username", with: "new_username"
      fill_in "Current password", with: "GenesysModule#1"
      click_button "Apply Changes"

      expect(page).to(have_content("Account updated successfully"))

      find("#user-account-dropdown .dropdown-toggle").click
      within("#user-account-dropdown") do
        click_link "Sign Out"
      end

      visit new_user_session_path
      fill_in "Email address or Username", with: "new_username"
      fill_in "Password", with: "GenesysModule#1"
      click_button "Log In"

      expect(page).to(have_content("Signed in successfully."))
    end
  end

  feature "Username at signup" do
    scenario "I cannot signup with an existing username" do
      visit new_user_registration_path

      fill_in "Email", with: "newuser@epigenesys.org.uk"
      fill_in "Username", with: user.username
      fill_in "Password", with: "GenesysModule#1"
      fill_in "Password confirmation", with: "GenesysModule#1"
      click_button "Sign Up"

      expect(page).to(have_content("Username has already been taken"))
    end

    scenario "I can signup with a non-existing username" do
      visit new_user_registration_path

      fill_in "Email", with: "newuser@epigenesys.org.uk"
      fill_in "Username", with: "newuniqueusername"
      fill_in "Password", with: "GenesysModule#1"
      fill_in "Password confirmation", with: "GenesysModule#1"
      click_button "Sign Up"

      expect(page).to(have_content("Welcome! You have signed up successfully."))
      expect(User.find_by(username: "newuniqueusername")).to(be_present)
    end
  end
end
