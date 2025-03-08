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
  factory :subscription_tier do
    name { "Free" }
    price_gbp { nil }
    discount_description { nil }
    terms_description { nil }

    trait :individual do
      name { "Individual" }
      price_gbp { 2.99 }
      discount_description { "Free for 1 month" }
      terms_description { "1 user only." }
    end
  end
end
