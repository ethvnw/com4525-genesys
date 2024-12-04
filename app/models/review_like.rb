# frozen_string_literal: true

##
# Model for review_likes linker table.
# Required as it will not be possible to use has_and_belongs_to_many in both
# Registration and Review, as the Registration instance won't be created until
# some time after the review has been liked.
class ReviewLike < ApplicationRecord
  belongs_to :review
  belongs_to :registration
end
