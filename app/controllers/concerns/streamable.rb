# frozen_string_literal: true

##
# Concern for controllers which require the ability to send turbo stream responses
module Streamable
  extend ActiveSupport::Concern

  included do
    def stream_response(options)
      respond_to do |format|
        format.turbo_stream do
          streams = Array(options[:streams])
          if options[:message]
            streams << turbo_toast(options[:message][:content], options[:message][:type])
          end

          render(turbo_stream: streams)
        end

        format.html do
          create_flash_message(options[:message])
          redirect_to(options[:redirect_path])
        end
      end
    end

    def turbo_redirect_to(redirect_path, message = nil)
      create_flash_message(message)
      stream_response(
        streams: turbo_stream.action(
          "redirect",
          redirect_path,
        ),
        redirect_path: redirect_path,
      )
    end

    def turbo_toast(message, notification_type)
      turbo_stream.append(
        "toast-list",
        partial: "partials/toast",
        locals: {
          notification_type: notification_type,
          message: message,
        },
      )
    end

    def create_flash_message(message)
      if message
        flash_type = message[:type] == "danger" ? :alert : :notice
        flash[flash_type] = message[:content]
      end
    end

    def turbo_stream_request?
      formats.any?(:turbo_stream)
    end
  end
end
