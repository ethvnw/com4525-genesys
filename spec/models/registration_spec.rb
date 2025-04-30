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
require_relative "../concerns/countable_shared_examples"

RSpec.describe(Registration, type: :model) do
  it_behaves_like "countable"

  describe "validations" do
    context "when no email is present" do
      it "is invalid" do
        expect(build(:registration, email: nil)).to(be_invalid)
      end
    end

    context "when email is invalid" do
      it "is invalid" do
        expect(build(:registration, email: "invalid")).to(be_invalid)
      end
    end

    context "when email had already been used" do
      it "is invalid" do
        create(:registration, email: "test@example.com")
        expect(build(:registration, email: "test@example.com")).to(be_invalid)
      end
    end

    context "when email is unused & valid" do
      it "is valid" do
        expect(build(:registration, email: "test@example.com")).to(be_valid)
      end
    end

    context "when no country code is present" do
      it "is invalid" do
        expect(build(:registration, country_code: nil)).to(be_invalid)
      end
    end

    context "when country code is not exactly 2 characters" do
      it "is invalid" do
        expect(build(:registration, country_code: "G")).to(be_invalid)
        expect(build(:registration, country_code: "GBR")).to(be_invalid)
      end
    end

    context "when country code is exactly 2 characters" do
      it "is valid" do
        expect(build(:registration, country_code: "GB")).to(be_valid)
      end
    end

    context "when no subscription tier ID is present" do
      it "is invalid" do
        expect(build(:registration, subscription_tier_id: nil)).to(be_invalid)
      end
    end

    context "when subscription tier ID does not exist" do
      it "is invalid" do
        expect(build(:registration, subscription_tier_id: 123)).to(be_invalid)
      end
    end

    context "when subscription tier ID exists" do
      let(:subscription_tier) { create(:subscription_tier) }

      it "is valid" do
        expect(build(:registration, subscription_tier_id: subscription_tier.id)).to(be_valid)
      end
    end
  end

  describe "counting methods" do
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

    describe ".count_by_country" do
      it "counts registrations by country" do
        by_country = Registration.count_by_country
        gb_country_obj = ISO3166::Country.new("GB")
        expect(by_country.count).to(eq(4))
        expect(by_country[gb_country_obj]).to(eq(3))
      end
    end
  end

  describe "#landing_page_journey" do
    it "retrieves the landing page journey that led to this registration" do
      registration = create(:registration)
      registration2 = create(:registration, email: "test2@example.com")

      create(:feature_share, registration: registration, created_at: Time.zone.parse("2024-01-06"))
      create(:feature_share, registration: registration, created_at: Time.zone.parse("2024-01-05"))
      create(:feature_share, registration: registration2)

      create(:review_like, registration: registration, created_at: Time.zone.parse("2024-01-04"))
      create(:review_like, registration: registration, created_at: Time.zone.parse("2024-01-03"))
      create(:review_like, registration: registration2)

      create(:question_click, registration: registration, created_at: Time.zone.parse("2024-01-02"))
      create(:question_click, registration: registration, created_at: Time.zone.parse("2024-01-01"))
      create(:question_click, registration: registration2)

      journey = registration.landing_page_journey

      expect(journey.length).to(eq(6))

      # Should contain only the journey points for registration, and should be sorted by created_at
      previous_datetime = Time.zone.parse("2023-12-31")
      journey.each do |journey_point|
        expect(journey_point.registration_id).to(eq(registration.id))
        expect(journey_point.created_at).to(be > previous_datetime)
        previous_datetime = journey_point.created_at
      end
    end
  end
end
