# frozen_string_literal: true

# Handles the displaying of subscription tiers
class SubscriptionTiersController < ApplicationController
  def pricing
    @subscription_tiers = SubscriptionTier.all
  end

  def register
    unless SubscriptionTier.exists?(id: params[:s_id])
      redirect_to(subscription_tiers_pricing_path) and return
    end

    @registration = Registration.new
  end
end
