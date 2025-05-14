# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ReviewDecorator, type: :decorator) do
  let(:review) { create(:review, name: "Sample Reviewer", content: "Sample Review") }
  let(:decorated_review) { review.decorate }

  describe "#subcontent" do
    it "returns the review name" do
      expect(decorated_review.subcontent).to(eq("Sample Reviewer"))
    end
  end

  describe "#engagement_icon" do
    it "returns the engagement icon" do
      expect(decorated_review.engagement_icon).to(eq("bi-hand-thumbs-up"))
    end
  end
end
