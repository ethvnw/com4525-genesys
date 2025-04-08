# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Analytics::JourneySaver) do
  let(:registration) { create(:registration) }
  let!(:feature) { create(:app_feature) }
  let!(:question1) { create(:question) }
  let!(:question2) { create(:question) }
  let!(:review1) { create(:review) }
  let!(:review2) { create(:review) }

  describe ".call" do
    context "when journey data is nil" do
      it "does not create any records" do
        Analytics::JourneySaver.call(registration.id, nil)

        expect(FeatureShare.count).to(be_zero)
        expect(QuestionClick.count).to(be_zero)
        expect(ReviewLike.count).to(be_zero)
      end
    end

    context "when journey data contains feature shares" do
      let(:feature_journey) do
        [
          {
            id: feature.id,
            method: "Mock Share Method",
            timestamp: Time.zone.parse("2024-01-01 09:00:45"),
          },
          {
            id: feature.id,
            method: "Mock Share Method 2",
            timestamp: Time.zone.parse("2024-01-01 09:01:21"),
          },
        ]
      end

      it "correctly creates feature share records" do
        Analytics::JourneySaver.call(registration.id, { "features" => feature_journey })

        expect(FeatureShare.find_by(
          app_feature_id: feature.id,
          registration_id: registration.id,
          share_method: "Mock Share Method",
          created_at: Time.zone.parse("2024-01-01 09:00:45"),
        )).to(be_present)

        expect(FeatureShare.find_by(
          app_feature_id: feature.id,
          registration_id: registration.id,
          share_method: "Mock Share Method 2",
          created_at: Time.zone.parse("2024-01-01 09:01:21"),
        )).to(be_present)
      end
    end

    context "when journey data contains question clicks" do
      let(:question_journey) do
        [
          {
            id: question1.id,
            timestamp: Time.zone.parse("2024-01-01 09:01:36"),
          },
          {
            id: question2.id,
            timestamp: Time.zone.parse("2024-01-01 09:02:43"),
          },
        ]
      end

      it "correctly creates question click records" do
        Analytics::JourneySaver.call(registration.id, { "questions" => question_journey })

        expect(QuestionClick.find_by(
          question_id: question1.id,
          registration_id: registration.id,
          created_at: Time.zone.parse("2024-01-01 09:01:36"),
        )).to(be_present)

        expect(QuestionClick.find_by(
          question_id: question2.id,
          registration_id: registration.id,
          created_at: Time.zone.parse("2024-01-01 09:02:43"),
        )).to(be_present)
      end
    end

    context "when journey data contains review likes" do
      let(:review_journey) do
        [
          {
            id: review1.id,
            timestamp: Time.zone.parse("2024-01-01 09:05:47"),
          },
          {
            id: review2.id,
            timestamp: Time.zone.parse("2024-01-01 09:07:18"),
          },
        ]
      end

      it "correctly creates review like records" do
        Analytics::JourneySaver.call(registration.id, { "reviews" => review_journey })

        expect(ReviewLike.find_by(
          review_id: review1.id,
          registration_id: registration.id,
          created_at: Time.zone.parse("2024-01-01 09:05:47"),
        )).to(be_present)

        expect(ReviewLike.find_by(
          review_id: review2.id,
          registration_id: registration.id,
          created_at: Time.zone.parse("2024-01-01 09:07:18"),
        )).to(be_present)
      end
    end

    context "when journey data contains all types of interactions" do
      let(:feature_journey) do
        [
          {
            id: feature.id,
            method: "Mock Share Method",
            timestamp: Time.zone.parse("2024-01-01 09:00:45"),
          },
        ]
      end

      let(:question_journey) do
        [
          {
            id: question1.id,
            timestamp: Time.zone.parse("2024-01-01 09:01:36"),
          },
        ]
      end

      let(:review_journey) do
        [
          {
            id: review1.id,
            timestamp: Time.zone.parse("2024-01-01 09:05:47"),
          },
        ]
      end

      it "correctly creates all types of records" do
        Analytics::JourneySaver.call(registration.id, {
          "features" => feature_journey,
          "questions" => question_journey,
          "reviews" => review_journey,
        })

        expect(FeatureShare.find_by(
          app_feature_id: feature.id,
          registration_id: registration.id,
          share_method: "Mock Share Method",
          created_at: Time.zone.parse("2024-01-01 09:00:45"),
        )).to(be_present)

        expect(QuestionClick.find_by(
          question_id: question1.id,
          registration_id: registration.id,
          created_at: Time.zone.parse("2024-01-01 09:01:36"),
        )).to(be_present)

        expect(ReviewLike.find_by(
          review_id: review1.id,
          registration_id: registration.id,
          created_at: Time.zone.parse("2024-01-01 09:05:47"),
        )).to(be_present)
      end
    end
  end
end
