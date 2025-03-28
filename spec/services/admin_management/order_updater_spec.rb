# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AdminManagement::OrderUpdater) do
  let(:test_question) { create(:question, is_hidden: false, order: 2) }

  # Force creation of questions with orders 1 and 3
  let!(:question_1) { create(:question, is_hidden: false, order: 1) }
  let!(:question_3) { create(:question, is_hidden: false, order: 3) }

  context "when moving up (order_change = -1)" do
    let(:order_change) { -1 }

    it "swaps order with the previous item" do
      described_class.call(Question, test_question.id, order_change)
      test_question.reload
      question_1.reload
      question_3.reload
      expect(test_question.order).to(eq(1))
      expect(question_1.order).to(eq(2))
      expect(question_3.order).to(eq(3))
    end

    it "returns true on successful swap" do
      expect(described_class.call(Question, test_question.id, order_change)).to(be(true))
    end
  end

  context "when moving down (order_change = 1)" do
    let(:order_change) { 1 }

    it "swaps order with the next item" do
      described_class.call(Question, test_question.id, order_change)
      test_question.reload
      question_1.reload
      question_3.reload
      expect(question_1.order).to(eq(1))
      expect(question_3.order).to(eq(2))
      expect(test_question.order).to(eq(3))
    end

    it "returns true on successful swap" do
      expect(described_class.call(Question, test_question.id, order_change)).to(be(true))
    end
  end

  context "when there is no item to swap with" do
    let(:order_change) { 1 }

    before do
      question_3.update(is_hidden: true)
    end

    it "returns false" do
      expect(described_class.call(Question, test_question.id, order_change)).to(be(false))
    end

    it "does not change the order of the current item" do
      original_order = test_question.order
      described_class.call(Question, test_question.id, order_change)
      expect(test_question.order).to(eq(original_order))
    end
  end
end
