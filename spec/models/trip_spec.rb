# frozen_string_literal: true

# == Schema Information
#
# Table name: trips
#
#  id                 :bigint           not null, primary key
#  description        :string
#  end_date           :datetime
#  location_latitude  :decimal(, )
#  location_longitude :decimal(, )
#  location_name      :string
#  start_date         :datetime
#  title              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
require "rails_helper"

RSpec.describe(Trip, type: :model) do
  describe "validations" do
    let(:trip) { build(:trip) }

    describe "#date_range_cant_be_blank" do
      context "when start_date is blank" do
        it "adds an error" do
          trip.start_date = nil
          expect(trip).to(be_invalid)
          expect(trip.errors[:date]).to(include("can't be blank"))
        end
      end

      context "when end_date is blank" do
        it "adds an error" do
          trip.end_date = nil
          expect(trip).to(be_invalid)
          expect(trip.errors[:date]).to(include("can't be blank"))
        end
      end

      context "when both dates are not blank" do
        it "validates successfully" do
          travel_to Time.zone.parse("2020-01-01")
          trip.end_date = Time.zone.now
          trip.start_date = Time.zone.now

          expect(trip).to(be_valid)
          expect(trip.errors[:date]).to(be_empty)
        end
      end
    end

    describe "#start_date_cannot_be_in_the_past" do
      before do
        travel_to Time.zone.parse("2020-01-01 16:00:00")
      end

      context "when start_date is in the past" do
        it "adds an error" do
          trip.start_date = Time.zone.now - 1.day
          expect(trip).to(be_invalid)
          expect(trip.errors[:start_date]).to(include("cannot be in the past"))
        end
      end

      context "when start_date is in the future" do
        it "validates successfully" do
          trip.start_date = Time.zone.now + 1.day
          expect(trip).to(be_valid)
          expect(trip.errors[:start_date]).to(be_empty)
        end
      end

      it "is time-agnostic" do
        trip.start_date = Time.zone.parse("2020-01-01 12:00:00")
        expect(trip).to(be_valid)
        expect(trip.errors[:start_date]).to(be_empty)
      end
    end

    describe "#location_cant_be_blank" do
      context "when location name is blank" do
        it "adds an error" do
          trip.location_name = nil
          expect(trip).to(be_invalid)
          expect(trip.errors[:location]).to(include("can't be blank"))
        end
      end

      context "when location latitude is blank" do
        it "adds an error" do
          trip.location_latitude = nil
          expect(trip).to(be_invalid)
          expect(trip.errors[:location]).to(include("can't be blank"))
        end
      end

      context "when location longitude is blank" do
        it "adds an error" do
          trip.location_longitude = nil
          expect(trip).to(be_invalid)
          expect(trip.errors[:location]).to(include("can't be blank"))
        end
      end

      context "when all location information is present" do
        it "validates successfully" do
          trip.location_name = "mock location"
          trip.location_latitude = 0.0
          trip.location_longitude = 0.0
          expect(trip).to(be_valid)
          expect(trip.errors[:location]).to(be_empty)
        end
      end
    end
  end
end
