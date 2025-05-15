# frozen_string_literal: true

require "rails_helper"

RSpec.describe(QuestionDecorator, type: :decorator) do
  let(:question) { create(:question, question: "How do I use Roamio?", answer: "Easily!") }
  let(:decorated_question) { question.decorate }

  describe "#content" do
    it "returns the question content" do
      expect(decorated_question.content).to(eq("How do I use Roamio?"))
    end
  end

  describe "#subcontent" do
    it "returns the answer content" do
      expect(decorated_question.subcontent).to(eq("Easily!"))
    end
  end

  describe "#engagement_icon" do
    it "returns the engagement icon" do
      expect(decorated_question.engagement_icon).to(eq("bi-hand-index"))
    end
  end
end
