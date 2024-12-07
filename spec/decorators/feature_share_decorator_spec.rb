# frozen_string_literal: true

require "rails_helper"

RSpec.describe(FeatureShareDecorator, type: :decorator) do
  let(:app_feature) { create(:app_feature, name: "Sample Feature") }
  let(:feature_share) { create(:feature_share, app_feature: app_feature, share_method: "email") }
  let(:decorated_feature_share) { feature_share.decorate }

  describe "#journey_title" do
    it "returns the name of the app feature" do
      expect(decorated_feature_share.journey_title).to eq("Sample Feature")
    end
  end

  describe "#journey_header" do
    it "returns a formatted header" do
      expect(decorated_feature_share.journey_header).to eq("Shared using Email")
    end
  end

  describe "#journey_icon" do
    it "returns the correct icon" do
      expect(decorated_feature_share.journey_icon).to eq("bi bi-share")
    end
  end
end