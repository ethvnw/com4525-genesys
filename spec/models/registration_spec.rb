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
  it "has a valid factory" do
    expect(build(:registration)).to(be_valid)
  end

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
end
