# frozen_string_literal: true

# == Schema Information
#
# Table name: subscription_tiers
#
#  id                   :bigint           not null, primary key
#  discount_description :string
#  name                 :string
#  price_gbp            :decimal(, )
#  terms_description    :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class SubscriptionTier < ApplicationRecord
  has_many :app_features_subscription_tiers
  has_many :app_features, through: :app_features_subscription_tiers

  def premium_subscription?
    price_gbp.present? && price_gbp > 0
  end
end
