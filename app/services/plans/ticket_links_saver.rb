# frozen_string_literal: true

module Plans
  # Service to save ticket links for a plan.
  # Usage:
  # Plans::TicketLinksSaver.call(plan: @plan, data: params[:ticket_links_data])
  # Creates a ticket link for each entry in the JSON data, linked to the plan.
  class TicketLinksSaver < ApplicationService
    def initialize(plan:, data:)
      super()
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
