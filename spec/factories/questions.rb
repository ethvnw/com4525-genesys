# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    question { "Placeholder question text" }
    is_hidden { false }
    engagement_counter { 0 }

    trait :hidden do
      is_hidden { true }
    end
  end
end
