# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Reporter dashboard") do
  let!(:reporter) { create(:reporter) }

  feature "Reporter can view statistics on dashboard", js: true do
    before do
      login_as(reporter, scope: :user)

      create(
        :landing_page_visit,
        country_code: "GB",
        created_at: Time.zone.now
      )

      create(
        :landing_page_visit,
        country_code: "GB",
        created_at: Time.zone.now.end_of_week - 2.days
      )

      visit reporter_dashboard_path
    end

    context "Reporter can view landing page views statistics" do  
      
      scenario "Reporter can view landing page views for today" do
        within(:css, "#today-tab .row .landing-page-views-card") do
          expect(page).to(have_content(2))
        end
      end


    end




  end
end
