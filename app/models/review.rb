# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id                 :bigint           not null, primary key
#  content            :text
#  engagement_counter :integer          default(0), not null
#  is_hidden          :boolean          default(TRUE)
#  name               :string(50)
#  order              :integer          default(-1), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Review < ApplicationRecord
  include Hideable

  has_many :review_likes, dependent: :destroy
  has_many :registrations, through: :review_likes
  validates :name, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 400 }
end
