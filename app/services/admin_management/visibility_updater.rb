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
      if @current_item.is_hidden
        # If showing, set order to the lowest unused order (or 1 if no currently shown items)
        new_order = [@model.maximum(:order) + 1, 1].max
        @current_item.update(is_hidden: false, order: new_order)
      else
        @model.transaction do
          # If hiding, decrease order of all subsequent items
          @model.where("#{@model.table_name}.order > ?", @current_item.order).each do |item|
            item.update(order: item.order - 1)
          end

          @current_item.update(is_hidden: true, order: -1)
        end
      end
    end
  end
end
