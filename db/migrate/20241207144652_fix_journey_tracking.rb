class FixJourneyTracking < ActiveRecord::Migration[7.0]
  def change
    remove_column :feature_shares, :updated_at
    remove_column :question_clicks, :updated_at
    remove_column :review_likes, :updated_at
  end
end
