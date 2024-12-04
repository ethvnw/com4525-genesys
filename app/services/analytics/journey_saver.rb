# frozen_string_literal: true

module Analytics
  ##
  # Base class for saving landing page journey to the database
  class JourneySaver < ApplicationService
    # @param [Integer] registration_id the ID of the registration to save the journey for
    # @param [Array<Hash>] journey the array of journey points
    def initialize(registration_id, journey)
      super()
      @registration_id = registration_id
      @journey = journey || []
    end
  end
end
