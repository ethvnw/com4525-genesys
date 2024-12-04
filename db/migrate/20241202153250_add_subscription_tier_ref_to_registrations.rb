class AddSubscriptionTierRefToRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_reference :registrations, :subscription_tier, null: false, foreign_key: true
  end
end
