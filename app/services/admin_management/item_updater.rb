# frozen_string_literal: true

module AdminManagement
  ##
  # Service class to update an item (a review or a question). Parent of OrderUpdater
  # and VisibilityUpdater
  class ItemUpdater < ApplicationService
    ##
    # @param [ApplicationRecord] model
    # @param [String] id
    def initialize(model, id)
      super()
      @model = model
      @current_item = @model.find(id)
    end
  end
end
