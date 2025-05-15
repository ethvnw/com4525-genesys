# frozen_string_literal: true

Sentry.init do |config|
  # Sentry is only enabled when the dsn is set.
  unless Rails.env.development? || Rails.env.test?
    config.dsn = "https://c9e62f6a1053c2ceaf1357856a3b5bf3@sentry.shefcompsci.org.uk/3"
  end
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.before_send = ->(event, _hint) {
    ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters).filter(event.to_hash)
  }
  config.excluded_exceptions += [
    "ActionController::BadRequest",
    "ActionController::UnknownFormat",
    "ActionController::UnknownHttpMethod",
    "ActionDispatch::Http::MimeNegotiation::InvalidType",
    "CanCan::AccessDenied",
    "Mime::Type::InvalidMimeType",
    "Rack::QueryParser::InvalidParameterError",
    "Rack::QueryParser::ParameterTypeError",
    "SystemExit",
    "URI::InvalidURIError",
  ]
end
