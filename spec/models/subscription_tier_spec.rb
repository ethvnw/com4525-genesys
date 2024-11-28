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
require "rails_helper"

RSpec.describe(SubscriptionTier, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end
