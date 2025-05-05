# frozen_string_literal: true

module Plans
  # Service to save booking references for a plan.
  # Usage:
  # Plans::BookingReferencesSaver.call(plan: @plan, data: params[:booking_references_data])
  # Creates a booking reference for each entry in the JSON data, linked to the plan.
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
