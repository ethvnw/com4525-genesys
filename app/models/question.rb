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
class Question < ApplicationRecord
  has_many :question_clicks, dependent: :destroy
  has_many :registrations, through: :question_clicks
  validates :question, presence: true, length: { maximum: 100 }
end
