# frozen_string_literal: true

module Plans
  # Service object to save booking references associated with a plan.
  # Accepts JSON data and creates BookingReference records.
  class BookingReferencesSaver < ApplicationService
    def initialize(plan:, data:)
      super()
      @plan = plan
      @data = data
    end

    def call
      return if @data.blank?

      JSON.parse(@data).each do |ref|
        @plan.booking_references.create(
          name: ref["name"],
          reference_number: ref["number"],
        )
      end
    end
  end
end
