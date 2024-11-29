class CreateAppFeaturesSubscriptionTiers < ActiveRecord::Migration[7.0]
  def change
    create_table :app_features_subscription_tiers do |t|
      t.references :app_feature, null: false, foreign_key: true
      t.references :subscription_tier, null: false, foreign_key: true

      t.timestamps
    end
  end
end
