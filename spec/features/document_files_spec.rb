# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing Documents") do
  let!(:user) { create(:user) }
  let!(:trip) { FactoryBot.create(:trip) }
  let!(:trip_membership) { create(:trip_membership, user: user, trip: trip) }
  given!(:plan) { create(:plan, trip: trip) }

  before do
    login_as(user, scope: :user)

    # Upload a single document at the start
    visit edit_trip_plan_path(trip, plan)
    attach_file("plan_documents", Rails.root.join("spec", "support", "files", "test.pdf"))
    click_on "Save"
    expect(page).to(have_content("Plan updated successfully."))
  end

  feature "Editing plans for documents" do
    scenario "I can upload PDF documents" do
      visit edit_trip_plan_path(trip, plan)

      # Upload document
      attach_file("plan_documents", Rails.root.join("spec", "support", "files", "test2.pdf"))
      click_on "Save"

      expect(page).to(have_content("Plan updated successfully."))

      # Click the dropdown to view documents
      within("#documents-accordion-#{plan.id}-#{plan.trip_id}") do
        find("button.accordion-button").click
      end

      # All documents uploaded should appear, existing and new
      expect(page).to(have_link("test.pdf"))
      expect(page).to(have_link("test2.pdf"))
    end

    scenario "I can remove PDF documents" do
      # Ensure the view document dropdown appears initially since a document exists
      expect(page).to(have_css("#documents-accordion-#{plan.id}-#{plan.trip_id}"))

      # Delete the document
      visit edit_trip_plan_path(trip, plan)
      # Because the document name is inside a span, it cannot be selected directly
      # However since there is only one document, we can just select the first one
      click_on "Remove"

      visit trip_path(plan.trip_id)
      # Document dropdown should no longer exist as no documents exists for that plan
      expect(page).to(have_no_css("#documents-accordion-#{plan.id}-#{plan.trip_id}"))
    end
  end
end
