# frozen_string_literal: true

Unsplash.configure do |config|
  config.application_access_key = Rails.application.credentials.dig(:unsplash, :access_key)
  config.application_secret = Rails.application.credentials.dig(:unsplash, :secret_key)
  config.utm_source = "Roamio"
end
