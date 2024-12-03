# frozen_string_literal: true

# == Schema Information
#
# Table name: app_features_subscription_tiers
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  app_feature_id       :bigint           not null
#  subscription_tier_id :bigint           not null
#
# Indexes
#
#  index_app_features_subscription_tiers_on_app_feature_id        (app_feature_id)
#  index_app_features_subscription_tiers_on_subscription_tier_id  (subscription_tier_id)
#
# Foreign Keys
#
#  fk_rails_...  (app_feature_id => app_features.id)
#  fk_rails_...  (subscription_tier_id => subscription_tiers.id)
#
FactoryBot.define do
  factory :app_features_subscription_tier do
    association :app_feature
    association :subscription_tier
  end
end
