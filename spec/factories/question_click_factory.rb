# frozen_string_literal: true

# == Schema Information
#
# Table name: question_clicks
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  question_id     :bigint
#  registration_id :bigint
#
# Indexes
#
#  index_question_clicks_on_question_id      (question_id)
#  index_question_clicks_on_registration_id  (registration_id)
#
FactoryBot.define do
  factory :question_click do
    association :question
    association :registration
  end
end