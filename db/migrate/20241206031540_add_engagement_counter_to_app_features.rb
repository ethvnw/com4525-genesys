class AddEngagementCounterToAppFeatures < ActiveRecord::Migration[7.0]
  def change
    add_column :app_features, :engagement_counter, :integer, default: 0, null: false
  end
end
