# frozen_string_literal: true

# Handles referrals made by users
class ReferralsController < ApplicationController
  before_action :authenticate_user!

  def create
    email = params[:email].to_s.downcase

    if User.exists?(email: email)
      flash[:alert] = "Cannot refer a user that already exists."
    else
      ReferralMailer.with(email: email, referrer: current_user).send_referral.deliver_later
      flash[:notice] = "Referral email sent to #{email}."
    end

    redirect_to(home_path)
  end
end
