# frozen_string_literal: true

# == Schema Information
#
# Table name: app_features
#
#  id                 :bigint           not null, primary key
#  description        :text
#  engagement_counter :integer          default(0), not null
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class AppFeature < ApplicationRecord
  has_many :app_features_subscription_tiers
  has_many :subscription_tiers, through: :app_features_subscription_tiers

  has_many :feature_shares
  has_many :registrations, through: :feature_shares

  has_one_attached :image

  class << self
    def get_features_by_tier(tier)
      SubscriptionTier.find_by(name: tier)&.app_features
    end

    def engagement_stats(tier)
      AppFeature.get_features_by_tier(tier)
        &.order(engagement_counter: :desc)
        &.pluck(:name, :engagement_counter) || []
    end
  end

  def increment_engagement_counter!
    increment!(:engagement_counter)
  end
end
