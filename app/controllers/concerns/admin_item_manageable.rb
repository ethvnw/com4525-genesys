# frozen_string_literal: true

##
# Concern for controllers which should be able to manage reviews/questions in the admin dashboard
module AdminItemManageable
  extend ActiveSupport::Concern

  included do
    def admin_item_stream_success_response(visible_items, hidden_items, fallback_path)
      stream_response(
        streams: [
          turbo_stream.update("visible-count", visible_items.count),
          turbo_stream.update("hidden-count", hidden_items.count),
          turbo_stream.update(
            "visible-items",
            partial: "partials/admin/admin_item_list",
            locals: { items: visible_items.decorate },
          ),
          turbo_stream.update(
            "hidden-items",
            partial: "partials/admin/admin_item_list",
            locals: { items: hidden_items.decorate },
          ),
        ],
        redirect_path: fallback_path,
      )
    end

    def admin_item_stream_error_response(message, fallback_path)
      stream_response(
        message: { content: message, type: "danger" },
        redirect_path: fallback_path,
      )
    end
  end
end
