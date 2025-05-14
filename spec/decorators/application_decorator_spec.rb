# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationDecorator, type: :decorator) do
  let(:registration) { create(:registration, country_code: "NL", created_at: Time.zone.parse("2024-01-01 13:43:03")) }
  let(:decorated_registration) { registration.decorate }

  describe "#formatted_timestamp" do
    it "returns the created_at attribute in a human-readable format" do
      expect(decorated_registration.formatted_timestamp).to(eq("January 01, 2024 01:43 PM"))
    end
  end

  describe "#formatted_country_name" do
    context "when the country code is valid" do
      it "returns the country name next to the emoji of the country's flag" do
        registration2 = create(:registration, country_code: "GB")
        decorated_registration2 = registration2.decorate

        expect(decorated_registration.formatted_country_name).to(eq("🇳🇱 Netherlands"))
        expect(decorated_registration2.formatted_country_name).to(eq("🇬🇧 United Kingdom"))
      end
    end

    context "when the country code is invalid" do
      it "returns an empty string" do
        invalid_registration = create(:registration, country_code: "XX")
        decorated_invalid_registration = invalid_registration.decorate

        expect(decorated_invalid_registration.formatted_country_name).to(eq(""))
      end
    end
  end

  describe "#format_date_slashes" do
    it "formats a date object to a string with slashes (dd/mm/yyyy)" do
      date = Date.new(2024, 4, 1)
      expect(decorated_registration.format_date_slashes(date)).to(eq("01/04/2024"))
    end
  end
end
