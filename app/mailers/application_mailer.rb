# frozen_string_literal: true

# Configures the mailer used by the application
class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@sheffield.ac.uk"
  layout "mailer"
end
