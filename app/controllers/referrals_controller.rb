# frozen_string_literal: true

# Handles referrals made by users
class ReferralsController < ApplicationController
  include Streamable
  before_action :authenticate_user!

  def create
    email = params[:email].to_s.downcase
    session[:referral_email] = email
    message = nil

    if User.exists?(email: email)
      flash[:errors] = {
        email: ["A user with that email already exists."],
      }
    elsif !(email =~ URI::MailTo::EMAIL_REGEXP)
      flash[:errors] = {
        email: ["Email is invalid."],
      }
    else
      ReferralMailer.with(email: email, referrer: current_user).send_referral.deliver_later
      session.delete(:referral_email)
      message = { type: "success", content: "Referral email sent to #{email}." }
      # Create a referral record
      Referral.create(sender_user: current_user, receiver_email: email)
    end

    stream_response("referrals/create", home_path, message)
  end
end
