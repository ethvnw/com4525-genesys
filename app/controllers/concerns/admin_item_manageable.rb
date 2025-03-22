# frozen_string_literal: true

##
# Concern for controllers which should be able to manage reviews/questions in the admin dashboard
module AdminItemManageable
  extend ActiveSupport::Concern

  included do
    def admin_item_stream_success_response(visible_items, hidden_items, fallback_path)
      @visible_items = visible_items
      @hidden_items = hidden_items
      stream_response("admin/items/success", fallback_path)
    end

    def admin_item_stream_error_response(message, fallback_path)
      respond_with_toast({ content: message, type: "danger" }, fallback_path)
    end
  end
end
