# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Visiting landing page") do
  specify "When visiting the landing page, a visit is tracked" do
    initial_count = LandingPageVisit.count

    visit root_path

    expect(LandingPageVisit.count).to(eq(initial_count + 1))
  end

  specify "When visiting the landing page, the visit location is tracked" do
    visit root_path

    expect(LandingPageVisit.last.country_code).to(eq("GB"))
  end
end
