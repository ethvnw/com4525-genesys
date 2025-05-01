# frozen_string_literal: true

# Mailer for referrals
class ReferralMailer < ApplicationMailer
  def send_referral
    @referrer = params[:referrer]
    @signup_url = new_user_registration_url

    mail(
      to: params[:email],
      subject: "#{@referrer.username} invited you to join Roamio!",
    )
  end
end
