# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id                 :bigint           not null, primary key
#  content            :text
#  engagement_counter :integer          default(0)
#  is_hidden          :boolean          default(TRUE)
#  name               :string(50)
#  order              :integer          default(-1), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :review do
    name { "Mock name" }
    content { "Mock review" }
    order { 1 }
    is_hidden { false }
    engagement_counter { 0 }

    factory :hidden_review do
      content { "Mock hidden review" }
      is_hidden { true }
      order { -1 }
    end
  end
end
