# frozen_string_literal: true

# == Schema Information
#
# Table name: subscription_tiers
#
#  id                   :bigint           not null, primary key
#  discount_description :string
#  engagement_counter   :integer          default(0), not null
#  name                 :string
#  price_gbp            :decimal(, )
#  terms_description    :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class SubscriptionTier < ApplicationRecord
  has_many :app_features_subscription_tiers
  has_many :app_features, through: :app_features_subscription_tiers

  class << self
    def engagement_stats
      SubscriptionTier&.order(engagement_counter: :desc)
        &.pluck(:name, :engagement_counter) || []
    end
  end

  def increment_engagement_counter!
    increment!(:engagement_counter)
  end

  def premium_subscription?
    price_gbp.present? && price_gbp.positive?
  end
end
