# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AdminManagement::VisibilityUpdater) do
  let(:model) { create(:question) }

  context "when showing a hidden item" do
    before do
      model.update(is_hidden: true, order: -1)
    end

    it "sets is_hidden to false" do
      described_class.call(Question, model.id)
      model.reload
      expect(model.is_hidden).to(be(false))
    end

    it "sets order to the next available order number" do
      create(:question, order: 1)
      create(:question, order: 2)
      described_class.call(Question, model.id)
      model.reload
      expect(model.order).to(eq(3))
    end

    it "sets order to 1 when no other items exist" do
      described_class.call(Question, model.id)
      model.reload
      expect(model.order).to(eq(1))
    end
  end

  context "when hiding a visible item" do
    let!(:question_2) { create(:question, order: 2) }
    let!(:question_3) { create(:question, order: 3) }

    before do
      model.update(is_hidden: false, order: 1)
    end

    it "sets is_hidden to true" do
      described_class.call(Question, model.id)
      model.reload
      expect(model.is_hidden).to(be(true))
    end

    it "sets order to -1" do
      described_class.call(Question, model.id)
      model.reload
      expect(model.order).to(eq(-1))
    end

    it "decreases the order of subsequent items" do
      described_class.call(Question, model.id)
      question_2.reload
      question_3.reload
      expect(question_2.order).to(eq(1))
      expect(question_3.order).to(eq(2))
    end
  end
end
