# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id                 :bigint           not null, primary key
#  answer             :text
#  engagement_counter :integer
#  is_hidden          :boolean          default(TRUE)
#  order              :integer          default(-1), not null
#  question           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :question do
    question { "Mock question" }
    is_hidden { false }
    engagement_counter { 0 }
    order { 1 }

    factory :hidden_question do
      question { "Mock hidden question" }
      is_hidden { true }
      order { -1 }
    end

    trait :with_answer do
      answer { "Mock answer" }
    end
  end
end
