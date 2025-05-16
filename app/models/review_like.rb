# frozen_string_literal: true

# == Schema Information
#
# Table name: review_likes
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  registration_id :bigint
#  review_id       :bigint
#
# Indexes
#
#  index_review_likes_on_registration_id  (registration_id)
#  index_review_likes_on_review_id        (review_id)
#
# Foreign Keys
#
#  fk_rails_...  (registration_id => registrations.id)
#  fk_rails_...  (review_id => reviews.id)
#
class ReviewLike < ApplicationRecord
  belongs_to :review
  belongs_to :registration
end
