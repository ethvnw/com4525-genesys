# frozen_string_literal: true

require_relative "development"

Rails.application.configure do
  # Setup logging to STDOUT
  if ENV["RAILS_LOG"].present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Enable web console in this env
  config.web_console.development_only = false
end
