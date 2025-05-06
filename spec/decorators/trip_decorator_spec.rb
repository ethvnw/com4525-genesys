# frozen_string_literal: true

require "rails_helper"

RSpec.describe(TripDecorator, type: :decorator) do
  before do
    travel_to Time.zone.parse("2000-01-01 1:00:00")
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

  describe "#formatted_date_range" do
    context "when start and end dates are in the same month and year" do
      let(:trip) { create(:trip, start_date: Time.zone.local(2000, 1, 5), end_date: Time.zone.local(2000, 1, 10)) }

      it "returns 'dd - dd mmm yyyy'" do
        expect(decorated_trip.formatted_date_range).to(eq("05 - 10 Jan 2000"))
      end
    end

    context "when start and end dates are in the same year but different months" do
      let(:trip) { create(:trip, start_date: Time.zone.local(2000, 1, 25), end_date: Time.zone.local(2000, 3, 5)) }

      it "returns 'dd mmm - dd mmm yyyy'" do
        expect(decorated_trip.formatted_date_range).to(eq("25 Jan - 05 Mar 2000"))
      end
    end

    context "when start and end dates are in different years" do
      let(:trip) { create(:trip, start_date: Time.zone.local(2000, 12, 30), end_date: Time.zone.local(2001, 1, 2)) }

      it "returns 'dd mmm yyyy - dd mmm yyyy'" do
        expect(decorated_trip.formatted_date_range).to(eq("30 Dec 2000 - 02 Jan 2001"))
      end
    end
  end

  describe "#webp_image" do
    context "when there is no trip image" do
      let(:trip) { create(:trip, image: nil) }
      it "returns nil" do
        expect(decorated_trip.webp_image).to(eq(nil))
      end
    end

    context "when there is a trip image" do
      let(:trip) { create(:trip) } # Use default mock image
      let(:image) { trip.image }
      it "returns a variant of the image that has been converted to webp" do
        expect(decorated_trip.webp_image.variation.transformations).to(include({ format: :webp, convert: :webp }))
      end

      it "returns a variant of the image that has been resized to fit within 1000x1000" do
        expect(decorated_trip.webp_image.variation.transformations).to(include({ resize_to_limit: [1000, 1000] }))
      end
    end
  end
end
