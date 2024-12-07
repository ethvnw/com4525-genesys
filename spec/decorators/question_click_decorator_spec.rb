# frozen_string_literal: true

require "rails_helper"

RSpec.describe(QuestionClickDecorator, type: :decorator) do
  let(:question) { create(:question, question: "Sample Question") }
  let(:question_click) { create(:question_click, question: question) }
  let(:decorated_question_click) { question_click.decorate }

  describe "#journey_title" do
    it "returns the name of the app feature" do
      expect(decorated_question_click.journey_title).to(eq("Sample Question"))
    end
  end

  describe "#journey_header" do
    it "returns a formatted header" do
      expect(decorated_question_click.journey_header).to(eq("Clicked on Question"))
    end
  end

  describe "#journey_icon" do
    it "returns the correct icon" do
      expect(decorated_question_click.journey_icon).to(eq("bi bi-hand-index"))
    end
  end
end
