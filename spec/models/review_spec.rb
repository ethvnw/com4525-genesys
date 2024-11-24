# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id                 :bigint           not null, primary key
#  content            :text
#  engagement_counter :integer
#  is_hidden          :boolean
#  name               :string
#  order              :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require "rails_helper"

RSpec.describe(Review, type: :model) do
  describe "#default_values" do
    it "sets the default values for the attributes of the review" do
      review = Review.new(name: "Test Name", content: "Content for the review")
      review.save
      expect(review.is_hidden).to(eq(true))
      expect(review.engagement_counter).to(eq(0))
      expect(review.order).to(eq(1))
    end
  end
end
