# frozen_string_literal: true

module AdminManagement
  ##
  # Service class for updating the visibility of an 'item' (a Review or a Question)
  #
  # Usage:
  # AdminManagement::VisibilityUpdater.call(Question, :id)
  class VisibilityUpdater < ItemUpdater
    def call
      currently_hidden = @current_item.is_hidden

      # If showing, set order to at least 1, otherwise -1
      new_order = currently_hidden ? [@model.maximum(:order) + 1, 1].max : -1

      @current_item.update(is_hidden: !currently_hidden, order: new_order)
    end
  end
end
