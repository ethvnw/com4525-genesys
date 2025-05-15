# frozen_string_literal: true

# == Schema Information
#
# Table name: question_clicks
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  question_id     :bigint
#  registration_id :bigint
#
# Indexes
#
#  index_question_clicks_on_question_id      (question_id)
#  index_question_clicks_on_registration_id  (registration_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#  fk_rails_...  (registration_id => registrations.id)
#
class QuestionClick < ApplicationRecord
  belongs_to :question
  belongs_to :registration
end
