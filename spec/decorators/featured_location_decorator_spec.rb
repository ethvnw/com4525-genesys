# frozen_string_literal: true

require "rails_helper"

RSpec.describe(FeaturedLocationDecorator) do
  let(:featured_location) do
    create(
      :featured_location,
      name: "The Peak District",
      country_code_iso: "GB",
    )
  end
  let(:decorated_featured_location) { featured_location.decorate }

  describe "#trip_name" do
    it "returns the trip name with the location name" do
      expect(decorated_featured_location.trip_name).to(eq("Trip to The Peak District"))
    end
  end

  describe "#location_name" do
    it "returns the location name with country code" do
      expect(decorated_featured_location.location_name).to(eq("The Peak District, GB"))
    end
  end

  describe "#truncated_country_name" do
    context "when common name is shorter than max length" do
      it "returns the common name" do
        expect(decorated_featured_location.truncated_country_name(20)).to(eq("United Kingdom"))
      end
    end

    context "when common name exceeds the provided max length" do
      it "returns the iso alpha2 code" do
        expect(decorated_featured_location.truncated_country_name(2)).to(eq("GB"))
      end
    end
  end
end
