# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id                 :bigint           not null, primary key
#  answer             :text
#  engagement_counter :integer
#  is_hidden          :boolean
#  question           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :question do
    question { "MyString" }
    answer { "MyText" }
    is_hidden { false }
    engagement_counter { 1 }
  end
end
