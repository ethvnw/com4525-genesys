class AddReviewIdToReviewLikes < ActiveRecord::Migration[7.0]
  def change
    add_reference :review_likes, :review, foreign_key: true
  end
end
