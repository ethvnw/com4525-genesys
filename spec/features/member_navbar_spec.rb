# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Member navbar") do
  let!(:member) { create(:user, username: "allisoncameron") }

  # TODO: Add tests for navigating using navbar
  feature "Member can navigate using the navbar" do
    before do
      login_as(member, scope: :user)
    end

    scenario "Accessing the home page" do
      visit home_path
    end

    scenario "Accessing the add page" do
      visit home_path
    end

    scenario "Accessing the trips page" do
      visit home_path
    end
  end

  # TODO: Ensure correct amount of notifications are displayed for trip invitations
  feature "Invitation notifications amount is displayed" do
  end
end
