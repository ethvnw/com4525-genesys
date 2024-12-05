# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Analytics::JourneySaver") do
  let(:registration) { create(:registration) }
  let!(:feature) { create(:app_feature) }
  let!(:question1) { create(:question) }
  let!(:question2) { create(:question) }
  let!(:review1) { create(:review) }
  let!(:review2) { create(:review) }

  context "when journey is nil" do
    it "does nothing" do
      Analytics::JourneySaver.call(registration.id, nil)

      expect(FeatureShare.count).to(eq(0))
      expect(QuestionClick.count).to(eq(0))
      expect(ReviewLike.count).to(eq(0))
    end
  end

  context "when journey is not nil" do
    it "saves the user's journey to the database" do
      feature_journey = [
        {
          id: feature.id,
          method: "Mock Share Method",
        },
        {
          id: feature.id,
          method: "Mock Share Method 2",
        },
      ]

      question_journey = [{ id: question1.id }, { id: question2.id }]
      review_journey = [{ id: review1.id }, { id: review2.id }]

      Analytics::JourneySaver.call(registration.id, {
        "features" => feature_journey,
        "questions" => question_journey,
        "reviews" => review_journey,
      })

      expect(
        FeatureShare.find_by(
          app_feature_id: feature.id,
          registration_id: registration.id,
          share_method: "Mock Share Method",
        ),
      ).to(be_present)

      expect(
        FeatureShare.find_by(
          app_feature_id: feature.id,
          registration_id: registration.id,
          share_method: "Mock Share Method 2",
        ),
      ).to(be_present)

      expect(ReviewLike.find_by(review_id: review1.id, registration_id: registration.id)).to(be_present)
      expect(ReviewLike.find_by(review_id: review2.id, registration_id: registration.id)).to(be_present)

      expect(QuestionClick.find_by(question_id: question1.id, registration_id: registration.id)).to(be_present)
      expect(QuestionClick.find_by(question_id: question2.id, registration_id: registration.id)).to(be_present)
    end
  end
end
