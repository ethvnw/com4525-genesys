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
#  order              :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Review < ApplicationRecord
  has_many :registrations, through: :review_likes
  validates :name, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 400 }
end
