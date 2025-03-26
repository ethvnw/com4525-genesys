# frozen_string_literal: true

##
# Concern for controllers which require the ability to send turbo stream responses
module Streamable
  extend ActiveSupport::Concern

  included do
    ##
    # Handles both Turbo Stream and HTML responses
    #
    # @param stream_template [String] the template to render for turbo stream requests
    # @param redirect_path [String] the path to redirect to for HTML requests
    # @param message [Hash, nil] optional message to display to the user as a toast
    # @option message [String] :content the content of the message
    # @option message [String] :type the type of message (e.g. "success", "danger", "info")
    #
    # @example
    #   stream_response(
    #     "reviews/create",
    #     root_path,
    #     { type: "success", content: "Successfully added review." }
    #   )
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

    ##
    # Can be used as a drop-in replacement for Rails' redirect_to, with added
    # support for custom messages as toasts.
    #
    # @param redirect_path [String] the path to redirect to
    # @param options [Hash] optional keyword arguments
    # @option options [String] :alert optional alert message
    # @option options [String] :notice optional notice message
    # @option options [Hash] :message optional message hash
    #
    # @example With notice (success message)
    #   turbo_redirect_to(root_path, notice: "Successfully registered!")
    #
    # @example With alert (danger message)
    #   turbo_redirect_to(root_path, alert: "An error occurred!")
    #
    # @example With custom message
    #   turbo_redirect_to(admin_dashboard_path, { content: "Access removed", type: "info" })
    def turbo_redirect_to(redirect_path, **options)
      @redirect_path = redirect_path

      if options[:alert].present?
        message = { content: options[:alert], type: "danger" }
      elsif options[:notice].present?
        message = { content: options[:notice], type: "success" }
      elsif options[:message].present?
        message = options[:message]
      end

      create_flash_message(message)
      stream_response("turbo_redirect", redirect_path)
    end

    ##
    # Handles responses that should only show a toast notification
    #
    # @param message [Hash] the message to display
    # @param fallback_path [String] the path to redirect to for HTML requests
    # @option message [String] :content the content of the message
    # @option message [String] :type the type of message (e.g. "success", "danger", "info")
    #
    # @example
    #   respond_with_toast(
    #     { type: "success", content: "Resource was successfully deleted." },
    #     resources_path
    #   )
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

    private

    ##
    # Adds a message to flash[:notifications]
    #
    # @param message [Hash, nil] the message to display
    # @option message [String] :content the content of the message
    # @option message [String] :type the type of message (e.g. "success", "danger", "info")
    #
    # @example
    #   create_flash_message({ type: "success", content: "Operation completed" })
    def create_flash_message(message)
      if message
        flash[:notifications] = [{ message: message[:content], notification_type: message[:type] }]
      end
    end
  end
end
