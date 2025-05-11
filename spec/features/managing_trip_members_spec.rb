# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing trip members") do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:trip) { create(:trip) }
  let(:trip_membership) { create(:trip_membership, user: user, trip: trip) }

  before do
    trip_membership # Prevent lazy evaluation
    login_as(user, scope: :user)
    travel_to(Time.zone.parse("2025-01-10 1:30:00"))
  end

  feature "Inviting trip members" do
    scenario "I can invite a trip member", js: true do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Manage Members"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("user")
      expect(page).to(have_selector(".aa-Item"))
      find_all(".aa-Item").first.click
      click_button "Invite"
      expect(page).to(have_content("User invited successfully"))
    end

    scenario "I cannot invite a trip member with no username", js: true do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Manage Members"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("")
      click_on "Cancel"
      click_button "Invite"
      expect(page).to(have_content("User must exist"))
    end

    scenario "I cannot invite a trip member when the trip is already at maximum capacity of members", js: true do
      stub_const("TripMembership::MAX_CAPACITY", 1)

      visit trip_path(trip)
      click_on "Settings"
      click_on "Manage Members"
      find(".aa-DetachedSearchButton").click
      find(".aa-Input").set("user")
      expect(page).to(have_selector(".aa-Item"))
      find_all(".aa-Item").first.click
      click_button "Invite"
      expect(page).to(
        have_content("The trip has reached the 1 member capacity, please remove a member before adding another."),
      )
    end
  end

  feature "Removing trip members" do
    given!(:trip_membership2) do
      create(:trip_membership, user: user2, sender_user: user, trip: trip, is_invite_accepted: true)
    end

    scenario "I can leave a trip myself and no longer have access to it", js: true do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Manage Members"
      accept_alert do
        click_on "Leave"
      end
      visit trip_path(trip)
      expect(page).not_to(have_content("Mock Trip"))
    end

    scenario "I can remove another member from the trip so they can no longer access it", js: true do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Manage Members"
      accept_alert do
        click_on "Remove"
      end
      await_message("User removed successfully")
      login_as(user2, scope: :user)
      visit trip_path(trip)
      expect(page).not_to(have_content("Mock Trip"))
    end
  end

  feature "Allowing/disallowing access to trips based on invite status" do
    given!(:plan) { create(:plan, trip: trip) }
    given!(:trip_membership2) do
      create(:trip_membership, user: user2, sender_user: user, trip: trip, is_invite_accepted: false)
    end
    before do
      login_as(user2, scope: :user)
    end

    scenario "I cannot access pages related to the trip before actioning the invite", js: true do
      visit trip_path(trip)
      expect(page).not_to(have_content("Mock Trip"))
      visit trip_trip_memberships_path(trip)
      expect(page).not_to(have_content("Manage Members"))
      visit new_trip_plan_path(trip)
      expect(page).not_to(have_content("New plan for Mock Trip"))
      visit edit_trip_plan_path(trip, plan)
      expect(page).not_to(have_content("Editing Mock Plan"))
    end

    scenario "I can reject the invitation to the trip", js: true do
      visit inbox_path
      accept_alert do
        find(".btn.btn-danger").click
      end
      visit trip_path(trip)
      expect(page).not_to(have_content("Mock Trip"))
    end

    scenario "I can accept the invitation to the trip and access related pages" do
      visit inbox_path
      find(".btn.btn-success").click
      visit trip_path(trip)
      expect(page).to(have_content("Mock Trip"))
    end
  end

  feature "Changing display name" do
    scenario "I can change my display name and see it in the members list", js: true do
      visit trip_path(trip)
      click_on "Settings"
      click_on "Change Trip Nickname"
      fill_in "trip_membership_user_display_name", with: "new name test"
      click_on "Update"
      click_on "Settings"
      click_on "Manage Members"
      expect(page).to(have_content("new name test"))
    end
  end
end
