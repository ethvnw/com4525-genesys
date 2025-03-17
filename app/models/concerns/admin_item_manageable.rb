# frozen_string_literal: true

##
# Concern for controllers which should be able to manage reviews/questions in the admin dashboard
module AdminItemManageable
  extend ActiveSupport::Concern

  included do
    def update_visibility
      if AdminManagement::VisibilityUpdater.call(model, params[:id])
        admin_item_stream_success_response
      else
        admin_item_stream_error_response("An error occurred while trying to update question visibility.")
      end
    end

    def update_order
      if AdminManagement::OrderUpdater.call(model, params[:id], params[:order_change].to_i)
        admin_item_stream_success_response
      else
        admin_item_stream_error_response("An error occurred while trying to update question order.")
      end
    end

    def admin_item_stream_success_response
      visible_items = model.visible
      hidden_items = model.hidden
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
        redirect_path: path,
      )
    end

    def admin_item_stream_error_response(message)
      stream_response(
        message: { content: message, type: "danger" },
        redirect_path: path,
      )
    end
  end
end
