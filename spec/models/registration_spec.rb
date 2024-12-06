# frozen_string_literal: true

# == Schema Information
#
# Table name: registrations
#
#  id                   :bigint           not null, primary key
#  country_code         :string
#  email                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  subscription_tier_id :bigint           not null
#
# Indexes
#
#  index_registrations_on_subscription_tier_id  (subscription_tier_id)
#
# Foreign Keys
#
#  fk_rails_...  (subscription_tier_id => subscription_tiers.id)
#
require "rails_helper"

RSpec.describe(Registration, type: :model) do
  describe "email validation" do
    it "is invalid when no email is present" do
      expect(build(:registration, email: nil)).to(be_invalid)
    end

    it "is invalid when email is invalid" do
      expect(build(:registration, email: "invalid")).to(be_invalid)
    end

    it "is invalid when email had already been used" do
      create(:registration, email: "test@example.com")
      expect(build(:registration, email: "test@example.com")).to(be_invalid)
    end
  end

  describe "country code validation" do
    it "is invalid when no country code is present" do
      expect(build(:registration, country_code: nil)).to(be_invalid)
    end

    it "is invalid when country code is not exactly 2 characters" do
      expect(build(:registration, country_code: "G")).to(be_invalid)
      expect(build(:registration, country_code: "GBR")).to(be_invalid)
    end
  end

  describe "subscription tier validation" do
    it "is invalid when no subscription tier ID is present" do
      expect(build(:registration, subscription_tier_id: nil)).to(be_invalid)
    end

    it "is invalid when subscription tier ID does not exist" do
      expect(build(:registration, subscription_tier_id: 123)).to(be_invalid)
    end
  end

  describe "grouping methods" do
    before do
      create(
        :registration,
        email: "test1@example.com",
        country_code: "GB",
        created_at: Time.zone.parse("2024-01-01 08:30:00"),
      )
      create(
        :registration,
        email: "test2@example.com",
        country_code: "NL",
        created_at: Time.zone.parse("2024-01-01 23:30:00"),
      )
      create(
        :registration,
        email: "test3@example.com",
        country_code: "GB",
        created_at: Time.zone.parse("2024-01-05 14:14:14"),
      )
      create(
        :registration,
        email: "test4@example.com",
        country_code: "US",
        created_at: Time.zone.parse("2024-01-26 08:30:00"),
      )
      create(
        :registration,
        email: "test5@example.com",
        country_code: "BE",
        created_at: Time.zone.parse("2024-07-26 08:30:00"),
      )
      create(
        :registration,
        email: "test6@example.com",
        country_code: "GB",
        created_at: Time.zone.parse("2025-01-01 08:30:00"),
      )
    end

    describe "by_day" do
      it "groups registrations by day" do
        by_day = Registration.by_day
        expect(by_day.count).to(eq(5))
        expect(by_day[Time.zone.parse("2024-01-01")].count).to(eq(2))
      end
    end

    describe "by_week" do
      it "groups registrations by week" do
        by_week = Registration.by_week
        expect(by_week.count).to(eq(4))
        expect(by_week[Time.zone.parse("2024-01-01")].count).to(eq(3))
      end
    end

    describe "by_month" do
      it "groups registrations by month" do
        by_month = Registration.by_month
        expect(by_month.count).to(eq(3))
        expect(by_month[Time.zone.parse("2024-01-01")].count).to(eq(4))
      end
    end

    describe "by_country" do
      it "groups registrations by country" do
        by_country = Registration.by_country
        expect(by_country.count).to(eq(4))
        expect(by_country["GB"].count).to(eq(3))
      end
    end
  end
end
3
