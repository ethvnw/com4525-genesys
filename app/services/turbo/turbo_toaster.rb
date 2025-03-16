# frozen_string_literal: true

module Turbo
  ##
  # Service class to render a toast and append it to the toast list using turbo streams
  # Params:
  # [String] notification_type - the type of toast to send (one of the 8 bootstrap types - see wiki/toasts.md)
  # [String] message - the message to send in the toast
  class TurboToaster < ApplicationService
    def initialize(notification_type, message)
      super() # Explicitly specify 0 arguments, otherwise it tries to call super with `feature`
      @notification_type = notification_type
      @message = message
    end

    def call
      render(turbo_stream: turbo_stream.append(
        "toast-list",
        partial: "toast",
        locals: {
          notification_type: type,
          message: message,
        },
      ))
    end
  end
end
