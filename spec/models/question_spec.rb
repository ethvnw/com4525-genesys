# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id                 :bigint           not null, primary key
#  answer             :text
#  engagement_counter :integer
#  is_hidden          :boolean
#  order              :integer          default(0)
#  question           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require "rails_helper"

RSpec.describe(Question, type: :model) do
  # FactoryBot tests
  it "creates a valid question" do
    question = create(:question)
    expect(question).to(be_valid)
  end

  it "creates a visible question by default" do
    question = create(:question)
    expect(question.is_hidden).to(be(false))
  end

  it "creates a hidden question" do
    question = create(:question, :hidden)
    expect(question.is_hidden).to(be(true))
  end
end
