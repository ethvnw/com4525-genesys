# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Visiting landing page") do
  specify "When visiting the landing page, a visit is tracked" do
    initial_count = LandingPageVisit.count

    visit root_path

    expect(LandingPageVisit.count).to(eq(initial_count + 1))
  end

  feature "landing page visit geolocation" do
    specify "When visiting the landing page with a geocodable IP, the visit location is tracked", vcr: true do
      ENV["TEST_IP_ADDR"] = "185.156.172.142" # IP address in Amsterdam
      visit root_path

      expect(LandingPageVisit.last.country_code).to(eq("NL"))

      ENV["TEST_IP_ADDR"] = "210.138.184.59" # IP address in Tokyo
      visit root_path

      expect(LandingPageVisit.last.country_code).to(eq("JP"))

      ENV["TEST_IP_ADDR"] = "178.238.11.6" # IP address in London
      visit root_path

      expect(LandingPageVisit.last.country_code).to(eq("GB"))
      ENV["TEST_IP_ADDR"] = nil
    end

    specify "When visiting the landing page with a non-geocodable IP, the visit location falls back to GB" do
      ENV["TEST_IP_ADDR"] = "127.0.0.1" # localhost
      visit root_path

      expect(LandingPageVisit.last.country_code).to(eq("GB"))

      ENV["TEST_IP_ADDR"] = nil
      visit root_path

      expect(LandingPageVisit.last.country_code).to(eq("GB"))
    end
  end
end
