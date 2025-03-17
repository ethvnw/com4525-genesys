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
          if options[:message]
            flash_type = options[:message][:type] == "danger" ? :alert : :notice
            flash[flash_type] = options[:message][:content]
          end
          redirect_to(options[:redirect_path])
        end
      end
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
  end
end
