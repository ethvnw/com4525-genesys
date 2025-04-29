# frozen_string_literal: true

# == Schema Information
#
# Table name: landing_page_visits
#
#  id           :bigint           not null, primary key
#  country_code :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "rails_helper"

RSpec.describe(LandingPageVisit, type: :model) do
  describe "counting methods" do
    before do
      create(
        :landing_page_visit,
        country_code: "GB",
        created_at: Time.zone.parse("2024-01-01 08:30:00"),
      )
      create(
        :landing_page_visit,
        country_code: "NL",
        created_at: Time.zone.parse("2024-01-01 23:30:00"),
      )
      create(
        :landing_page_visit,
        country_code: "GB",
        created_at: Time.zone.parse("2024-01-05 14:14:14"),
      )
      create(
        :landing_page_visit,
        country_code: "US",
        created_at: Time.zone.parse("2024-01-26 08:30:00"),
      )
      create(
        :landing_page_visit,
        country_code: "BE",
        created_at: Time.zone.parse("2024-07-26 08:30:00"),
      )
      create(
        :landing_page_visit,
        country_code: "GB",
        created_at: Time.zone.parse("2025-01-01 08:30:00"),
      )
    end

    describe ".by_day" do
      it "counts landing page visits by day" do
        by_day = LandingPageVisit.by_day
        expect(by_day[Time.zone.parse("2024-01-01")]).to(eq(2))
      end
    end

    describe ".by_week" do
      it "counts landing page visits by week" do
        by_week = LandingPageVisit.by_week
        expect(by_week[Time.zone.parse("2024-01-01")]).to(eq(3))
      end
    end

    describe ".by_month" do
      it "counts landing page visits by month" do
        by_month = LandingPageVisit.by_month
        expect(by_month[Time.zone.parse("2024-01-01")]).to(eq(4))
      end
    end

    describe ".by_country" do
      it "counts landing page visits by country" do
        by_country = LandingPageVisit.by_country
        gb_country_obj = ISO3166::Country.new("GB")
        expect(by_country.count).to(eq(4))
        expect(by_country[gb_country_obj]).to(eq(3))
      end
    end
  end
end
