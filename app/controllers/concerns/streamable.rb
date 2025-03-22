# frozen_string_literal: true

##
# Concern for controllers which require the ability to send turbo stream responses
module Streamable
  extend ActiveSupport::Concern

  included do
    def stream_response(stream_template, redirect_path, message = nil)
      respond_to do |format|
        format.turbo_stream do
          @message = message
          render("turbo_stream_templates/#{stream_template}", layout: "turbo_stream")
        end

        format.html do
          create_flash_message(message)
          redirect_to(redirect_path)
        end
      end
    end

    def turbo_redirect_to(redirect_path, message = nil)
      @redirect_path = redirect_path
      create_flash_message(message)
      stream_response("turbo_redirect", redirect_path)
    end

    def respond_with_toast(message, fallback_path)
      respond_to do |format|
        format.turbo_stream do
          render(
            partial: "turbo_stream_templates/turbo_toast",
            locals: { notification_type: message[:type], message_content: message[:content] },
          )
        end

        format.html do
          create_flash_message(message)
          redirect_to(fallback_path)
        end
      end
    end

    def create_flash_message(message)
      if message
        flash_type = message[:type] == "danger" ? :alert : :notice
        flash[flash_type] = message[:content]
      end
    end
  end
end
