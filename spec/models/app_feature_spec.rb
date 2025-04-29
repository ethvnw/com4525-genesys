# frozen_string_literal: true

# spec/models/app_feature_spec.rb
require "rails_helper"

# == Schema Information
#
# Table name: app_features
#
#  id                 :bigint           not null, primary key
#  description        :text
#  engagement_counter :integer          default(0), not null
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

RSpec.describe(AppFeature, type: :model) do
  let!(:app_feature_1) { create(:app_feature, name: "App Feature 1", engagement_counter: 5) }
  let!(:app_feature_2) { create(:app_feature, name: "App Feature 2", engagement_counter: 20) }
  let!(:app_feature_3) { create(:app_feature, name: "App Feature 3", engagement_counter: 10) }
  let!(:tier) do
    create(:subscription_tier, name: "Individual", app_features: [app_feature_1, app_feature_2, app_feature_3])
  end

  describe ".engagement_stats" do
    it "returns app features ordered by engagement_counter in descending order" do
      engagement_stats = AppFeature.engagement_stats(:Individual)
      expect(engagement_stats).to(eq([[app_feature_2.name, 20], [app_feature_3.name, 10], [app_feature_1.name, 5]]))
    end
  end

  describe ".get_features_by_tier" do
    context "when the tier exists" do
      it "returns the app features for the tier" do
        expect(AppFeature.get_features_by_tier("Individual")).to(match_array([
          app_feature_1,
          app_feature_2,
          app_feature_3,
        ]))
      end
    end

    context "when the tier does not exist" do
      it "returns nil" do
        expect(AppFeature.get_features_by_tier("NotaRealTier")).to(be_nil)
      end
    end
  end

  describe "#increment_engagement_counter!" do
    let!(:feature) { create(:app_feature, engagement_counter: 0) }

    it "increments the engagement counter by 1" do
      expect { feature.increment_engagement_counter! }.to(change { feature.engagement_counter }.by(1))
    end
  end
end
