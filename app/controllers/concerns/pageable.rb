# frozen_string_literal: true

##
# Concern to assist with pagination
module Pageable
  extend ActiveSupport::Concern

  included do
    ##
    # Clear unwanted parameters from URL when paging, to allow for different
    # behaviour between infinite scroll and regular pagination.
    def clear_paging_parameters
      @infinite_scroll = params[:scroll] == "infinite"

      # Delete infinite scroll parameter (keeping it in will prevent sorting from working,
      # as it will append to the list, rather than updating)
      request.query_parameters.delete(:scroll)

      if @infinite_scroll
        # If using infinite scroll, delete the page parameter
        # Allows changing order to function correctly (will always go to page 0) on mobile
        request.query_parameters.delete(:page)
      end
    end
  end
end
