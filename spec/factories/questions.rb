# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id                 :bigint           not null, primary key
#  answer             :text
#  engagement_counter :integer
#  is_hidden          :boolean          default(TRUE)
#  order              :integer
#  question           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
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
