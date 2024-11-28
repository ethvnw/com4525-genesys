# frozen_string_literal: true

# Handles the displaying of subscription tiers
class SubscriptionTiersController < ApplicationController
  def pricing
    @subscription_tiers = SubscriptionTier.all
  end
end
