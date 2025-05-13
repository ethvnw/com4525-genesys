# frozen_string_literal: true

module Plans
  # Service to save scannable tickets for a plan.
  # Usage:
  # Plans::ScannableTicketsSaver.call(
  #   plan: @plan,
  #   scannable_tickets: params[:scannable_tickets],
  #   titles: params[:scannable_ticket_titles],
  # )
  # Creates a scannable ticket for each entry in the JSON data, linked to the plan.
  # @return [Boolean] true if any duplicate codes were found, false otherwise.
  class ScannableTicketsSaver < ApplicationService
    def initialize(plan:, scannable_tickets:, titles:)
      super()
      @plan = plan
      @scannable_tickets = scannable_tickets.present? ? JSON.parse(scannable_tickets) : []
      @titles = titles.present? ? JSON.parse(titles) : []
    end

    def call
      any_duplicate_codes = false

      @scannable_tickets.each_with_index do |code, index|
        # Check if the code already exists before creating a new one
        if @plan.scannable_tickets.exists?(code: code)
          any_duplicate_codes = true
        else
          @plan.scannable_tickets.create(code: code, title: @titles[index], ticket_format: :qr)
        end
      end
      any_duplicate_codes
    end
  end
end
