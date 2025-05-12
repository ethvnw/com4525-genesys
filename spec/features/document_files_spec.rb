# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing Documents") do
  let!(:user) { create(:user) }
  let!(:trip) { create(:trip) }
  let!(:trip_membership) { create(:trip_membership, user: user, trip: trip) }
  let!(:plan) { create(:plan, trip: trip) }

  before do
    login_as(user, scope: :user)

    # Upload a single document at the start
    visit edit_trip_plan_path(trip, plan)

    within("#accordion-documents") do
      find("button.accordion-button").click
      expect(page).to(have_selector("input#plan_documents", visible: true))
      attach_file("plan_documents", Rails.root.join("spec", "support", "files", "test.pdf"))
    end

    click_on "Save"
    expect(page).to(have_content("Plan updated successfully."))
  end

  feature "Editing plans for documents" do
    scenario "I can upload PDF documents" do
      visit edit_trip_plan_path(trip, plan)

      within("#accordion-documents") do
        find("button.accordion-button").click
        expect(page).to(have_selector("input#plan_documents", visible: true))
        attach_file("plan_documents", Rails.root.join("spec", "support", "files", "test2.pdf"))
      end

      click_on "Save"

      expect(page).to(have_content("Plan updated successfully."))

      Bullet.enable = false
      visit trip_plan_path(trip, plan)
      Bullet.enable = true

      within("#accordion-documents") do
        find("button.accordion-button").click
        # All documents uploaded should appear, existing and new
        expect(page).to(have_link("test.pdf"))
        expect(page).to(have_link("test2.pdf"))
      end
    end

    scenario "I can remove PDF documents", js: true do
      # Delete the document
      visit edit_trip_plan_path(trip, plan)
      # Because the document name is inside a span, it cannot be selected directly
      # However since there is only one document, the first one can be selected
      within("#accordion-documents") do
        find("button.accordion-button").click
        expect(page).to(have_selector("input#plan_documents", visible: true))
        accept_alert do
          click_on "Remove"
        end
      end

      Bullet.enable = false
      visit trip_plan_path(trip, plan)
      Bullet.enable = true
      # Document dropdown should no longer exist as no documents exists for that plan
      expect(page).to(have_no_css("#accordion-documents"))
    end
  end
end
