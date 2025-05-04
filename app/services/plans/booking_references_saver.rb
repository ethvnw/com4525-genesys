# frozen_string_literal: true

module Plans
  # Service object to save booking references associated with a plan.
  # Accepts JSON data and creates BookingReference records.
  class BookingReferencesSaver
    class << self
      def call(plan:, data:)
        new(plan, data).call
      end
    end

    def initialize(plan, data)
      @plan = plan
      @data = data
    end

    # Parses the JSON data and creates BookingReference records for each reference.
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
