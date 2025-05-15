# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ScannableTicketDecorator, type: :decorator) do
  let(:scannable_ticket) { create(:scannable_ticket, title: "Sample Ticket", code: "12345") }
  let(:decorated_ticket) { scannable_ticket.decorate }

  describe "#title_value" do
    it "returns 'Untitled Ticket' if the title is the same as the code" do
      scannable_ticket.update(title: scannable_ticket.code)
      expect(decorated_ticket.title_value).to(eq("Untitled Ticket"))
    end

    it "returns the actual title if it's different from the code" do
      expect(decorated_ticket.title_value).to(eq("Sample Ticket"))
    end
  end
end
