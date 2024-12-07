# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ReviewLikeDecorator, type: :decorator) do
  let(:review) { create(:review, name: "Sample Reviewer", content: "Sample Review") }
  let(:review_like) { create(:review_like, review: review) }
  let(:decorated_review_like) { review_like.decorate }

  describe "#journey_title" do
    it "returns the name of the app feature" do
      expect(decorated_review_like.journey_title).to(eq("Sample Review"))
    end
  end

  describe "#journey_header" do
    it "returns a formatted header" do
      expect(decorated_review_like.journey_header).to(eq("Liked Review"))
    end
  end

  describe "#journey_icon" do
    it "returns the correct icon" do
      expect(decorated_review_like.journey_icon).to(eq("bi bi-hand-thumbs-up"))
    end
  end
end
