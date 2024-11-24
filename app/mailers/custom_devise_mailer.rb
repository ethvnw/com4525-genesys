# frozen_string_literal: true

# A custom mailer to help send magic password links for staff only
class CustomDeviseMailer < Devise::Mailer
  def send_magic_password_instructions(record, token, opts = {})
    @token = token
    @resource = record
    devise_mail(record, :send_magic_password_instructions, opts)
  end
end
