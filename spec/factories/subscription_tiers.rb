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
FactoryBot.define do
  factory :free_tier, class: SubscriptionTier do
    name { "Free" }
    price_gbp { nil }
    discount_description { nil }
    terms_description { nil }
    engagement_counter { 0 }
  end

  factory :individual_tier, class: SubscriptionTier do
    name { "Individual" }
    price_gbp { 10 }
    discount_description { "Free for 1 month" }
    terms_description { "1 user only." }
    engagement_counter { 0 }
  end
end
