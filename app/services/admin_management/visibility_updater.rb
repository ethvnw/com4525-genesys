# frozen_string_literal: true

module AdminManagement
  class VisibilityUpdater < ItemUpdater
    def call
      currently_hidden = @current_item.is_hidden
      new_order = currently_hidden ? @model.maximum(:order) + 1 : -1

      @current_item.update(is_hidden: !currently_hidden, order: new_order)
    end
  end
end
