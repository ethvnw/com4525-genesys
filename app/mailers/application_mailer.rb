# frozen_string_literal: true

# Configures the mailer used by the application
class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@roamiotravel.co.uk"
  layout "mailer"
end
