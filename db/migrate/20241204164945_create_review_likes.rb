class CreateReviewLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :review_likes do |t|

      t.timestamps

      t.belongs_to :review
      t.belongs_to :registration
    end
  end
end
