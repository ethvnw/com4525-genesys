# frozen_string_literal: true

# Decorator for subscription tier
class SubscriptionTierDecorator < ApplicationDecorator
  delegate_all

  def formatted_price
    price = object.price_gbp
    return "" unless price.present? && price > 0

    if price % 1 == 0
      format("£%d/month", price.to_i)
    else
      format("£%.2f/month", price)
    end
  end

  def formatted_cta
    return "Get #{object.name}" unless object.premium_subscription?

    "Get Explorer #{object.name}"
  end
end
