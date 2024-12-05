# frozen_string_literal: true

# == Schema Information
#
# Table name: review_likes
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  registration_id :bigint
#  review_id       :bigint
#
# Indexes
#
#  index_review_likes_on_registration_id  (registration_id)
#  index_review_likes_on_review_id        (review_id)
#
class ReviewLike < ApplicationRecord
  belongs_to :review
  belongs_to :registration
end
