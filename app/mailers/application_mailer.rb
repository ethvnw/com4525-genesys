# frozen_string_literal: true

# Configures the application's mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@sheffield.ac.uk'
  layout 'mailer'
end
