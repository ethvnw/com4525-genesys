# frozen_string_literal: true

module Plans
  # Service object to save ticket links associated with a plan.
  # Accepts JSON data and creates TicketLink records.
  class TicketLinksSaver
    class << self
      def call(plan:, data:)
        new(plan, data).call
      end
    end

    def initialize(plan, data)
      @plan = plan
      @data = data
    end

    # Parses the JSON data and creates TicketLink records for each link.
    def call
      return if @data.blank?

      JSON.parse(@data).each do |link|
        @plan.ticket_links.create(
          name: link["name"],
          link: link["url"],
        )
      end
    end
  end
end
