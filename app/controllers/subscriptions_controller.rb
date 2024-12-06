# frozen_string_literal: true

# Handles the displaying of subscription tiers
class SubscriptionsController < ApplicationController
  def pricing
    @subscription_tiers = SubscriptionTier.all.order(id: :asc)
  end

  def new
    unless SubscriptionTier.exists?(id: params[:s_id])
      redirect_to(pricing_subscriptions_path) and return
    end

    # Get the app feature and increment its engagement counter
    subscription_tier = SubscriptionTier.find_by_id(params[:s_id])
    subscription_tier.increment_engagement_counter!
    subscription_tier.save

    @registration = Registration.new
  end
end
