class AddEngagementCounterToSubscriptionTiers < ActiveRecord::Migration[7.0]
  def change
    add_column :subscription_tiers, :engagement_counter, :integer, default: 0, null: false
  end
end
