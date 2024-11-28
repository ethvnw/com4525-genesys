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
FactoryBot.define do
  factory :subscription_tier do
    name { "MyString" }
    price_gbp { "9.99" }
    discount_description { "MyString" }
    terms_description { "MyString" }
  end
end
