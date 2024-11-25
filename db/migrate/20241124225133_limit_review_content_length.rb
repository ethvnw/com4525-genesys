class LimitReviewContentLength < ActiveRecord::Migration[7.0]
  def change
    change_column :reviews, :content, :text, limit: 400
    change_column :reviews, :name, :string, limit: 50
  end
end
