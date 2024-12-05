# frozen_string_literal: true

# Handles the displaying of subscription tiers
class SubscriptionsController < ApplicationController
  def pricing
    @subscription_tiers = SubscriptionTier.all
  end

  def new
    unless SubscriptionTier.exists?(id: params[:s_id])
      redirect_to(pricing_subscriptions_path) and return
    end

    @registration = Registration.new
  end
end
