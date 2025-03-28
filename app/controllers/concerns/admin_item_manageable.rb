# frozen_string_literal: true

##
# Concern for controllers which should be able to manage reviews/questions in the admin dashboard
module AdminItemManageable
  extend ActiveSupport::Concern
  include Streamable

  included do
    ##
    # Creates a turbo stream response for successful requests in item management
    #
    # @param visible_items [ActiveRecord::Relation] the visible items
    # @param hidden_items [ActiveRecord::Relation] the hidden items
    # @param fallback_path [String] the path to redirect to for HTML requests
    def admin_item_stream_success_response(visible_items, hidden_items, fallback_path)
      @visible_items = visible_items
      @hidden_items = hidden_items
      stream_response("admin/items/success", fallback_path)
    end
  end
end
