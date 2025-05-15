# frozen_string_literal: true

require "rails_helper"

RSpec.describe(PlansHelper, type: :helper) do
  describe("#booking_reference_value") do
    let(:plan_with_booking_reference) { create(:plan, :with_booking_reference) }

    context "when param_data is present" do
      let(:param_data) { '[{"name":"Test Name","number":"123456"}]' }

      it "returns the param_data" do
        expect(helper.booking_reference_value(param_data, plan_with_booking_reference)).to(eq(param_data))
      end
    end

    context "when param_data is not present" do
      it "returns the JSON representation of the existing booking references" do
        expected_json = [
          {
            name: plan_with_booking_reference.booking_references.first.name,
            number: plan_with_booking_reference.booking_references.first.reference_number,
          },
        ].to_json

        expect(helper.booking_reference_value(nil, plan_with_booking_reference)).to(eq(expected_json))
      end
    end
  end

  describe("#ticket_link_value") do
    let(:plan_with_ticket_link) { create(:plan, :with_ticket_link) }

    context "when param_data is present" do
      let(:param_data) { '[{"name":"Test Name","url":"https://example.com"}]' }

      it "returns the param_data" do
        expect(helper.ticket_link_value(param_data, plan_with_ticket_link)).to(eq(param_data))
      end
    end

    context "when param_data is not present" do
      it "returns the JSON representation of the existing ticket links" do
        expected_json = [
          {
            name: plan_with_ticket_link.ticket_links.first.name,
            url: plan_with_ticket_link.ticket_links.first.link,
          },
        ].to_json

        expect(helper.ticket_link_value(nil, plan_with_ticket_link)).to(eq(expected_json))
      end
    end
  end

  describe("#render_plan_partial") do
    let(:trip) { create(:trip) }
    let(:travel_plan) { create(:plan, plan_type: :travel_by_plane) }
    let(:event_plan) { create(:plan, plan_type: :active) }

    context "when the plan is a travel plan" do
      it "renders the travel_card partial" do
        expect(helper).to(receive(:render).with("partials/plans/travel_card", trip: trip, plan: travel_plan))
        helper.render_plan_partial(travel_plan, trip)
      end
    end

    context "when the plan is an event plan" do
      it "renders the event_card partial" do
        expect(helper).to(receive(:render).with("partials/plans/event_card", trip: trip, plan: event_plan))
        helper.render_plan_partial(event_plan, trip)
      end
    end
  end
end
