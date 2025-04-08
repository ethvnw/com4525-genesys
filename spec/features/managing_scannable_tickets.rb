# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing plans") do
  let(:user) { create(:user) }
  let(:trip) { FactoryBot.create(:trip) }

  before do
    login_as(user, scope: :user)
    travel_to(Time.parse("2025-01-10 1:30:00"))
    stub_photon_api
  end

  feature "Delete a scannable ticket" do
    let(:plan_with_ticket) { create(:scannable_ticket).plan }

    scenario "I can delete a scannable and see it removed from the plan" do
      # Check that the ticket is present in the plan
      visit edit_trip_plan_path(trip, plan_with_ticket)
      within("#scannable-tickets-table") do
        expect(page).to(have_content("Mock ticket code"))
      end
      click_on("Remove")
      expect(page).to(have_content("Scannable ticket deleted successfully."))
      # Check that the ticket is removed from the plan
      visit edit_trip_plan_path(trip, plan_with_ticket)
      expect(page).not_to(have_selector("#scannable-tickets-table"))
      expect(page).not_to(have_content("Mock ticket code"))
    end
  end
end
