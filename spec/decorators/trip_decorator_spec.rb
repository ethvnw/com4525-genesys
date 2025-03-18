# frozen_string_literal: true

require "rails_helper"

RSpec.describe(TripDecorator, type: :decorator) do
  before do
    travel_to Time.parse("2000-01-01 1:00:00")
  end

  let(:trip) { create(:trip, start_date: Time.zone.now, end_date: Time.zone.now + 1.hour) }
  let(:decorated_trip) { trip.decorate }

  describe "#formatted_start_date" do
    it "returns the start date as 'dd/mm/yyyy'" do
      expect(decorated_trip.formatted_start_date).to(eq("01/01/2000"))
    end
  end

  describe "#formatted_end_date" do
    it "returns the end date as 'dd/mm/yyyy'" do
      expect(decorated_trip.formatted_end_date).to(eq("01/01/2000"))
    end
  end
end
