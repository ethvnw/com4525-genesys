# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Error Pages") do
  let(:user) { create(:user) }

  scenario "shows the 401 page for unauthorized access", :error_page do
    login_as(user)

    # Visit a route not available to users
    visit admin_dashboard_path

    expect(page).to(have_content("Response Status Code 401"))
    expect(page.status_code).to(eq(401))
  end

  scenario "shows the 404 page for a non-existent route", :error_page do
    visit "/non-existent-route"

    expect(page).to(have_content("Response Status Code 404"))
    expect(page.status_code).to(eq(404))
  end

  scenario "shows the 500 page for an internal server error", :error_page do
    # Stub pages controller and raise a server error
    allow_any_instance_of(PagesController).to(receive(:landing).and_raise(StandardError))

    visit root_path

    expect(page).to(have_content("Response Status Code 500"))
    expect(page.status_code).to(eq(500))
  end
end
