class CreateReviewLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :review_likes do |t|
      t.datetime :timestamp
    end
  end
end
