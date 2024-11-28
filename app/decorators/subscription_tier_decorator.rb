# frozen_string_literal: true

# Decorator for subscription tier
class SubscriptionTierDecorator < ApplicationDecorator
  delegate_all

  def formatted_price
    return "" unless object.price_gbp.present? && object.price_gbp > 0

    "£#{object.price_gbp}/month"
  end

  def formatted_cta
    return "Get #{object.name}" unless object.premium_subscription?

    "Get Explorer #{object.name}"
  end
end
