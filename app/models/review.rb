# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id                 :bigint           not null, primary key
#  content            :text
#  engagement_counter :integer
#  is_hidden          :boolean
#  name               :string
#  order              :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Review < ApplicationRecord
  validates :content, presence: true
  validates :name, presence: true
  before_save :default_values

  def default_values
    self.is_hidden = true
    self.engagement_counter = 0
    self.order = Review.count + 1
  end
end
