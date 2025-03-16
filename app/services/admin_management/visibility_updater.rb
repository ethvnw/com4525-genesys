# frozen_string_literal: true

module AdminManagement
  ##
  # Service class to update the visibility of questions or reviews
  #
  # Params:
  # [Review || Question] model - the model class to use
  # [String] id - the ID of the row that should have its order updated
  class VisibilityUpdater < ItemUpdater
    def call
      currently_hidden = @current_item.is_hidden

      # If showing, set order to the lowest unused order, otherwise -1
      new_order = currently_hidden ? [@model.maximum(:order) + 1, 1].max : -1

      @current_item.update(is_hidden: !currently_hidden, order: new_order)
    end
  end
end
