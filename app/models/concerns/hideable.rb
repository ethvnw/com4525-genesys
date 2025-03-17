# frozen_string_literal: true

##
# Concern for models which have a :is_hidden attribute
module Hideable
  extend ActiveSupport::Concern

  class_methods do
    def visible
      all.where(is_hidden: false).order(order: :asc, created_at: :asc)
    end

    def hidden
      all.where(is_hidden: true).order(order: :asc, created_at: :asc)
    end
  end
end
