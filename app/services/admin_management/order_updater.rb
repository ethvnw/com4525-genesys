# frozen_string_literal: true

module AdminManagement
  class OrderUpdater < ItemUpdater
    def initialize(model, id, order_change)
      super(model, id)
      @order_change = order_change
    end

    def call
      # Get sign of order change & find question to swap with
      order_change_sign = @order_change >= 0 ? 1 : -1
      swap_with = @model.find_by(is_hidden: false, order: @current_item.order + order_change_sign)

      # Swap orders of the two questions in a transaction
      begin
        @model.transaction do
          swap_with.update(order: @current_item.order)
          @current_item.update(order: @current_item.order + order_change_sign)
        end
        true
      rescue
        false
      end
    end
  end
end
